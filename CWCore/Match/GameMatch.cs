using CWCore.Cards;
using CWCore.Decks;
using CWCore.Exceptions;
using CWCore.Match.Phases;
using CWCore.Match.Players;
using CWCore.Match.Scripts;
using CWCore.Match.States;
using CWCore.Utility;
using Microsoft.Extensions.Logging;
using NLua;

namespace CWCore.Match;

public class GameMatch {
    private static readonly List<IPhase> _phases = new(){
        new TurnStartPhase(),
        new ActionPhase(),
        new FightPhase(),
        new TurnEndPhase()
    };

    public IIDGenerator CardIDGenerator { get; set; } = new BasicIDGenerator();
    public ILogger? Logger { get; set; } = null;
    public IMatchView? View { get; set; } = null;
    public Random Rng { get; }

    public MatchConfig Config { get; }
    private readonly ICardMaster _cardMaster;
    public List<Player> Players { get; } = new();
    public Lua LState { get; } = new();
    public MatchState LastState { get; set; }

    public Update QueuedUpdate { get; private set; } = new();

    private int _winnerI = -1;
    public string PhaseName { get; private set; } = "";

    public bool Active => _winnerI < 0;

    public int CurPlayerI { get; private set; }
    public int TurnCount { get; private set; } = 0;

    public List<LuaFunction> UEOTEffects { get; }
    public List<LuaFunction> AEOTEffects { get; }

    public List<string> CardsPlayed { get; } = new();

    public GameMatch(MatchConfig config, int seed, ICardMaster cardMaster, string setupScript) {
        _cardMaster = cardMaster;
        Config = config;

        Rng = new(seed);
        CurPlayerI = 0;
        if (config.RandomFirstPlayer)
            CurPlayerI = Rng.Next() % 2;

        LogInfo("Running setup script");
        LState.DoString(setupScript);

        _ = new ScriptMaster(this);
        LastState = new();

        UEOTEffects = new();
        AEOTEffects = new();
    }

    public async Task AddPlayer(string name, DeckTemplate template, IPlayerController controller) {
        if (Players.Count == 2) {
            throw new GameMatchException("can't add player to match - already full");
        }
        
        var deck = await template.ToDeck(Players.Count, _cardMaster, LState, CardIDGenerator);

        Hero? hero = null;
        if (!string.IsNullOrEmpty(template.Hero)) {
            hero = new Hero(
                await _cardMaster.GetHero(template.Hero),
                Players.Count,
                LState
            );
        }
        var player = new Player(
            this,
            name,
            Players.Count,
            template.Landscapes,
            deck,
            hero,
            controller
        );

        Players.Add(player);
    }

    public Player GetPlayer(int playerI) {
        if (playerI < 0 || playerI >= Players.Count) {
            throw new GameMatchException($"playerI {playerI} is invalid");
        }
        return Players[playerI];
    }

    public PlayerState GetPlayerState(int playerI) {
        if (playerI < 0 || playerI >= Players.Count) {
            throw new GameMatchException($"playerI {playerI} is invalid");
        }
        return LastState.Players[playerI];
    }

    public void LogInfo(string info) {
        Logger?.LogInformation(info);
    }

    public void LogWarning(string msg) {
        Logger?.LogWarning(msg);
    }

    public void LogError(string msg) {
        Logger?.LogError(msg);
        
        throw new GameMatchException(msg);
    }

    public async Task Run() {
        if (Players.Count < 2)
            throw new GameMatchException("match not full");

        await Setup();
        await Turns();
        await CleanUp();
    }

    private async Task Setup() {
        foreach (var player in Players) {
            LogInfo($"Running setup for player {player.LogFriendlyName}");
            await player.Setup();
        }

        LogInfo("Starting view");
        View?.Start(this);

        LogInfo("Pushing initial state");
        await PushUpdates();

        LogInfo("Setup complete");
    }

    public Player CurrentPlayer => Players[CurPlayerI];

    private async Task Turns() {
        LogInfo("Started main match loop");

        // Logger.ParseAndLog("Match started");
        while (Active) {
            TurnCount++;

            await ReloadState();
            if (!Active) return;

            var cPlayer = CurrentPlayer;

            LogInfo($"Player {cPlayer.LogFriendlyName} starts their turn");
            // Logger.ParseAndLog(cPlayer.Name + " started their turn.");

            foreach (var phase in _phases) {
                PhaseName = phase.GetName();
                await phase.PreEmit(this, CurPlayerI);
                await Emit(PhaseName, new(){ {"playerI", CurPlayerI} });
                await phase.PostEmit(this, CurPlayerI);
                
                await ReloadState();
                if (!Active) return;
            }
            // Logger.ParseAndLog("Player " + cPlayer.Name + " passed their turn.");
            
            CurPlayerI = 1 - CurPlayerI;
        }
    }

    private async Task CleanUp() {
        LogInfo("Performing cleanup");

        // TODO add back
        // foreach (var player in Players) {
        //     await player.Controller.CleanUp();
        // }

        if (View is not null)
            await View.End();
    }

    public async Task PushUpdates() {
        if (View is not null) {
            await View.Update(this);
        }
        // TODO
        
        foreach (var player in Players) {
            await player.UpdateController();
        }
    }

    public async Task ReadyCard(InPlayCard card) {
        card.Ready();
        // TODO? add to update
    }

    public async Task ExhaustToAttack(CreatureState card) {
        // TODO should be done in card
        var c = card.GetOriginal();
        c.Status = InPlayCardStatus.ATTACKING;
        c.Attacking = true;
        // TODO? add to update
    }

    public void ActionError(string err) {
        if (!Config.StrictMode) {
            LogWarning(err);
            return;
        }
        throw new GameMatchException(err);
    }

    public async Task<int> DealDamageToPlayer(int playerI, int amount) {
        var player = GetPlayer(playerI);
        // TODO add trigger
        // TODO? add to update    
        var dealt = await player.ProcessDamage(amount);

        return dealt;
    }

    public async Task<int> DealDamageToPlayerBy(int playerI, CreatureState attacker) {
        var amount = attacker.GetAttack() * attacker.DamageMultiplier;
        var dealt = await DealDamageToPlayer(playerI, amount);
        attacker.OnDealtDamage(dealt, null);

        return dealt;
    }

    public async Task SoftReloadState() {
        LastState = new(this);
        LState["STATE"] = LastState;
        LastState.Modify();
    }

    public async Task ReloadState() {
        await SoftReloadState();

        await CheckDeadPlayers();
        await CheckDeadCreatures();

        await PushUpdates();
    }

    public async Task CheckDeadPlayers() {
        foreach (var player in Players) {
            if (player.Life <= 0) {
                _winnerI = player.Idx;
                break;
            }
        }
    }

    public Task DealDamageToCreature(CreatureState creature, int amount, LuaTable sourceTable) {
        amount = creature.CalcDamage(amount, sourceTable);
        
        creature.GetOriginal().Damage += amount;
        creature.OnDamaged(amount, sourceTable);

        // TODO add update
        // TODO add trigger
        LogInfo($"{creature.Original.Card.LogFriendlyName} is dealt {amount} damage");

        return Task.CompletedTask;
    }

    public async Task DealDamageToCreature(CreatureState creature, int amount, CreatureState from) {
        var source = LuaUtility.CreateTable(LState);
        source["type"] = (int)DamageSource.CREATURE;
        source["id"] = from.Original.Card.ID;
        source["ownerI"] = from.Original.ControllerI;

        await DealDamageToCreature(creature, amount, source);
    }

    public async Task DealDamageToCreatureBy(CreatureState to, CreatureState from) {
        var damage = from.GetAttack() * from.DamageMultiplier;
        await DealDamageToCreature(to, damage, from);
        if (to.ShouldDie())
            from.OnDefeated(to.GetOriginal());
        from.OnDealtDamage(damage, to.Original.Card.ID);

    }

    public async Task DestroyCreature(string id) {
        var creature = GetInPlayCreature(id);
        var player = GetPlayerState(creature.Original.Card.OwnerI);
        var landscape = GetPlayerState(creature.Original.ControllerI).Landscapes[creature.LaneI];
        await DestroyCreature(player, landscape);
    }

    public async Task DestroyCreature(PlayerState player, LandscapeState landscape) {
        var creature = landscape.Creature
            ?? throw new GameMatchException($"tried to destroy creature in landscape {landscape.GetName()}, where it is not present")
        ;

        landscape.Original.Creature = null;
        landscape.Creature = null;

        await player.Original.LeavePlay(landscape, creature);
        
        // TODO add trigger

        LogInfo($"{creature.Original.Card.LogFriendlyName} in lane {creature.LaneI} dies!");
    }

    public async Task DestroyBuilding(string id) {
        var building = GetInPlayBuilding(id);
        var player = GetPlayerState(building.Original.Card.OwnerI);
        var landscape = GetPlayerState(building.Original.ControllerI).Landscapes[building.LaneI];
        await DestroyBuilding(player, landscape, building);
    }

    public async Task DestroyBuilding(PlayerState player, LandscapeState landscape, InPlayCardState building) {
        var removed = landscape.Original.Buildings.Remove(building.Original);

        if (!removed) {
            throw new GameMatchException($"tried to destroy building in landscape {landscape.GetName()}, where it is not present");
        }

        await player.Original.LeavePlay(landscape, building);
        landscape.Buildings.Remove(building);
        
        // TODO add trigger

        LogInfo($"{building.Original.Card.LogFriendlyName} in lane {building.LaneI} is destroyed!");
    }

    public async Task CheckDeadCreatures() {
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                var creature = lane.Creature;
                if (creature is null) continue;

                if (!creature.ShouldDie()) continue;

                await DestroyCreature(player, lane);
            }
        }
    }

    public CreatureState GetInPlayCreature(string id) {
        return GetInPlayCreatureOrDefault(id)
            ?? throw new GameMatchException($"Failed to find in-play creature with id {id}")
        ;
    }

    public InPlayCardState GetInPlayBuilding(string id) {
        return GetInPlayBuildingOrDefault(id)
            ?? throw new GameMatchException($"Failed to find in-play building with id {id}")
        ;
    }
    
    public CreatureState? GetInPlayCreatureOrDefault(string id) {
        foreach (var player in LastState.Players)
            foreach (var lane in player.Landscapes)
                if (lane.Creature is not null && lane.Creature.Original.Card.ID == id)
                    return lane.Creature;
        return null;
    }

    public InPlayCardState? GetInPlayBuildingOrDefault(string id) {
        foreach (var player in LastState.Players)
            foreach (var lane in player.Landscapes)
                foreach (var building in lane.Buildings)
                    if (building.Original.Card.ID == id)
                        return building;
        return null;
    }

    public InPlayCardState GetInPlayCard(string id) {
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                if (lane.Creature is not null && lane.Creature.Original.Card.ID == id)
                    return lane.Creature;
                foreach (var building in lane.Buildings)
                    if (building.Original.Card.ID == id)
                        return building;
            }
        }
        throw new GameMatchException($"Failed to find in-play card with id {id}");
    }

    public async Task FloopCard(InPlayCardState card) {
        card.Original.Status = InPlayCardStatus.FLOOPED;
        // TODO? add update
    }

    public async Task Emit(string signal, Dictionary<string, object> args) {
        var logMessage = "Emitted signal " + signal + ", args: ";
        var argsTable = LuaUtility.CreateTable(LState, args);
        foreach (var pair in args) {
            logMessage += pair.Key + ":" + pair.Value.ToString() + " ";
        }
        LogInfo(logMessage);
        await ReloadState();

        foreach (var player in LastState.Players) {
            // heroes
            var hero = player.Original.Hero;
            if (hero is not null && hero.TriggeredAbilities.Count > 0) {
                foreach (var trigger in hero.TriggeredAbilities) {
                    var on = trigger.Trigger;
                    if (on != signal) continue;

                    var canTrigger = trigger.ExecCheck(player, argsTable);
                    if (!canTrigger) {
                        continue;
                    }

                    var payedCosts = trigger.ExecCosts(player, argsTable);
                    if (!payedCosts) {
                        continue;
                    }

                    LogInfo($"Hero card {hero.LogFriendlyName} triggers!");
                    trigger.ExecEffect(player, argsTable);
                }
            }

            // landscapes
            foreach (var lane in player.Landscapes) {
                var cards = new List<InPlayCardState>();
                if (lane.Creature is not null && lane.Creature.TriggeredAbilities.Count > 0) {
                    cards.Add(lane.Creature);
                }
                cards.AddRange(lane.Buildings);
                foreach (var card in cards) {
                    foreach (var trigger in card.TriggeredAbilities) {
                        var on = trigger.Trigger;
                        if (on != signal) continue;

                        var canTrigger = trigger.ExecCheck(player, card, lane.Original.Idx, argsTable);
                        if (!canTrigger) {
                            continue;
                        }

                        var payedCosts = trigger.ExecCosts(player, card, lane.Original.Idx, argsTable);
                        if (!payedCosts) {
                            continue;
                        }

                        LogInfo($"Card {card.Original.Card.LogFriendlyName} triggers!");
                        trigger.ExecEffect(player, card, lane.Original.Idx, argsTable);
                    }
                }
            }
        }

        LogInfo($"Finished emitting {signal}");
    }

    public async Task TurnLandscapeFaceDown(LandscapeState landscape) {
        if (landscape.Original.FaceDown) {
            LogWarning($"Trying to flip a face-down landscape face-down");
            return;
        }
        
        landscape.Original.FaceDown = true;
        // TODO update
        // TODO trigger
    }

    public async Task TurnLandscapeFaceUp(LandscapeState landscape) {
        if (!landscape.Original.FaceDown) {
            LogWarning($"Trying to flip a face-up landscape face-up");
            return;
        }
        
        landscape.Original.FaceDown = false;
        // TODO update
        // TODO trigger
    }

    public async Task MoveCreature(string creatureId, int toI) {
        foreach (var player in LastState.Players) {
            foreach (var landscape in player.Landscapes) {
                var creature = landscape.Creature;
                if (creature is null || creature.Original.Card.ID != creatureId) continue;

                var prevLaneI = landscape.Original.Idx;
                if (prevLaneI == toI) {
                    ActionError($"Tried to move creature {creature.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}, which are the same");
                    return;
                }

                var newLane = player.Landscapes[toI];

                if (newLane.Original.Creature is not null)
                    throw new GameMatchException($"tried to move a creature to lane {toI}, which is not empty");
                    
                landscape.Original.Creature = null;
                newLane.Original.Creature = creature.GetOriginal();

                await SoftReloadState();

                creature.OnMove(player.Original.Idx, prevLaneI, toI);

                // TODO? add update
                // TODO trigger

                LogInfo($"Moved creature {creature.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}");
                return;
            }
        }
        throw new GameMatchException($"failed to find creature with id {creatureId} to move to lane {toI}");
    }

    public async Task SwapCreatures(string id1, string id2) {
        // TODO implement swapping with opponent's creatures

        var creature1 = GetInPlayCreature(id1);
        var creature2 = GetInPlayCreature(id2);

        var landscape1 = Players[creature1.Original.ControllerI].Landscapes[creature1.LaneI];
        var landscape2 = Players[creature2.Original.ControllerI].Landscapes[creature2.LaneI];

        (landscape1.Creature, landscape2.Creature) = (landscape2.Creature, landscape1.Creature);

        await SoftReloadState();

        // TODO hope i didn't confuse these two
        creature1.OnMove(creature2.Original.ControllerI, landscape1.Idx, landscape2.Idx);
        creature2.OnMove(creature1.Original.ControllerI, landscape2.Idx, landscape1.Idx);
    }

    public async Task MoveBuilding(string buildingId, int toI) {
        // * mostly repeated code from MoveCreature
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                var building = lane.Buildings.FirstOrDefault(b => b.Original.Card.ID == buildingId);
                if (building is null) continue;

                var prevLaneI = lane.Original.Idx;
                if (prevLaneI == toI) {
                    ActionError($"Tried to move building {building.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}, which are the same");
                    return;
                }

                var newLane = player.Landscapes[toI];

                if (newLane.Original.Buildings.Count > 0)
                    throw new GameMatchException($"tried to move a building to lane {toI}, which is not empty");
                    
                lane.Original.Buildings.Remove(building.Original);
                newLane.Original.Buildings.Add(building.Original);

                await SoftReloadState();

                building.OnMove(player.Original.Idx, prevLaneI, toI);

                // TODO? add update
                // TODO trigger

                LogInfo($"Moved building {building.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}");
                return;
            }
        }
        throw new GameMatchException($"failed to find building with id {buildingId} to move to lane {toI}");
    }

    public async Task HealDamage(CreatureState creature, int amount) {
        var original = creature.GetOriginal();
        original.Damage -= amount;
        if (original.Damage < 0) original.Damage = 0;

        // TODO trigger
        // TODO update
    }

    public async Task PlaceTokenOnLandscape(int playerI, int laneI, string token) {
        var player = GetPlayer(playerI);
        player.Landscapes[laneI].Tokens.Add(token);

        await Emit("token_placed_on_landscape", new(){ 
            {"playerI", playerI},
            {"laneI", laneI},
            {"token", token},
        });
        // TODO update
    }

    public async Task StealCreature(int fromPlayerI, string creatureId, int toLaneI) {
        var player = GetPlayerState(fromPlayerI);
        var newOwner = GetPlayerState(1 - fromPlayerI);
        var newLane = newOwner.Landscapes[toLaneI];
        if (newLane.Creature is not null ){
            throw new GameMatchException($"tried to steal a creature to lane {toLaneI}, which is not empty");
        }

        foreach (var landscape in player.Landscapes) {
            var creature = landscape.Creature;
            if (creature is null) continue;
            if (creature.Original.Card.ID != creatureId) continue;

            landscape.Original.Creature = null;
            newLane.Original.Creature = creature.GetOriginal();
            creature.Original.ControllerI = newOwner.Original.Idx;

            await SoftReloadState();
            creature.OnMove(newOwner.Original.Idx, landscape.Original.Idx, toLaneI, true);

            LogInfo($"Player {newOwner.Original.LogFriendlyName} stole creature {creature.Original.Card.LogFriendlyName} from player {player.Original.LogFriendlyName} from lane {landscape.Original.Idx} to lane {toLaneI}");

            return;
        }
        throw new GameMatchException($"failed to find creature with id {creatureId} to steaal to lane {toLaneI}");
    }

    public async Task<List<MatchCard>> RevealCardsFromDeck(int playerI, int amount) {
        var player = GetPlayer(playerI);
        var deck = player.Deck;

        var result = new List<MatchCard>();
        for (int i = 0; i < amount; i++) {
            var deckI = deck.Count - i - 1;
            var card = deck.ElementAt(deckI);
            result.Add(card);

            LogInfo($"Player {player.LogFriendlyName} revealed {card.LogFriendlyName} from the top of their deck");
        }
        // TODO add update
        return result;
    }

    public async Task RevealCardsFromHand(int playerI, int cardI) {
        var player = GetPlayerState(playerI);

        var card = player.Hand[cardI];

        LogInfo($"Player {player.Original.LogFriendlyName} revealed {card.Original.LogFriendlyName} from their hand");
    }
}