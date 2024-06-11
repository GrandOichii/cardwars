using CWCore.Cards;
using CWCore.Decks;
using CWCore.Exceptions;
using CWCore.Match.Effects;
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
        new BattlePhase(),
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
    private readonly ScriptMaster _scriptMaster;
    public MatchState LastState { get; set; }

    public Update QueuedUpdate { get; private set; } = new();

    private int _winnerI = -1;

    public bool Active => _winnerI < 0;

    public int CurPlayerI { get; private set; }
    public int TurnCount { get; private set; } = 0;

    public List<LuaFunction> UEOTEffects { get; }

    public GameMatch(MatchConfig config, int seed, ICardMaster cardMaster, string setupScript) {
        _cardMaster = cardMaster;
        Config = config;

        // TODO add seeding
        Rng = new(seed);

        LogInfo("Running setup script");
        LState.DoString(setupScript);

        _scriptMaster = new(this);
        LastState = new();
        UEOTEffects = new();
    }

    public async Task AddPlayer(string name, DeckTemplate template, IPlayerController controller) {
        if (Players.Count == 2) {
            throw new GameMatchException("can't add player to match - already full");
        }
        
        var deck = await template.ToDeck(Players.Count, _cardMaster, LState, CardIDGenerator);
        var player = new Player(this, name, Players.Count, template.Landscapes, deck, controller);

        Players.Add(player);
    }

    public Player GetPlayer(int playerI) {
        if (playerI >= Players.Count) {
            throw new CWCoreException($"playerI {playerI} is invalid");
        }
        return Players[playerI];
    }

    public PlayerState GetPlayerState(int playerI) {
        if (playerI >= Players.Count) {
            throw new CWCoreException($"playerI {playerI} is invalid");
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
        
        throw new CWCoreException(msg);
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
        View?.Start();

        LogInfo("Pushing initial state");
        await PushUpdates();

        LogInfo("Setup complete");
    }

    public Player CurrentPlayer => Players[CurPlayerI];
    public Player Opponent => Players[1 - CurPlayerI];

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
                await phase.Exec(this, CurPlayerI);
                
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
        
    }

    public async Task ReadyCard(InPlayCard card) {
        card.Ready();
        // TODO? add to update
    }

    public async Task ExhaustToAttack(Creature card) {
        card.Exhausted = true;
        card.Attacking = true;
        // TODO? add to update
    }

    public void ActionError(string err) {
        if (!Config.StrictMode) {
            LogWarning(err);
            return;
        }
        throw new CWCoreException(err);
    }

    public async Task<int> DealDamageToPlayer(int playerI, int amount) {
        var player = GetPlayer(playerI);
        // TODO add trigger
        // TODO? add to update    
        var dealt = await player.ProcessDamage(amount);

        return dealt;
    }

    public async Task ReloadState() {
        // TODO ordering
        await CheckDeadPlayers();
        await CheckDeadCreatures();

        await PushUpdates();
        LastState = new(this);
        LState["STATE"] = LastState;
        LastState.Modify();
    }

    public async Task CheckDeadPlayers() {
        foreach (var player in Players) {
            if (player.Life <= 0) {
                _winnerI = player.Idx;
                break;
            }
        }
    }

    public async Task DealDamageToCreature(Creature creature, int amount) {
        creature.Damage += amount;
        // TODO add update
        // TODO add trigger
        LogInfo($"{creature.Card.LogFriendlyName} is dealt {amount} damage");
    }

    public async Task DestroyCreature(PlayerState player, LandscapeState landscape) {
        var creature = landscape.Creature
            ?? throw new CWCoreException($"tried to destroy creature in landscape {landscape.Original.Name}, where it is not present")
        ;

        landscape.Original.Creature = null;

        await player.Original.LeavePlay(landscape.Original, creature.Original);
        
        // TODO add trigger

        LogInfo($"{creature.Original.Card.LogFriendlyName} in lane {creature.LaneI} dies!");

    }

    public async Task CheckDeadCreatures() {
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                var creature = lane.Creature;
                if (creature is null) continue;

                if (creature.Defense > creature.GetDamage()) continue;

                await DestroyCreature(player, lane);
            }
        }
    }

    public CreatureState GetInPlayCreature(string id) {
        var result = GetInPlayCreatureOrDefault(id)
            ?? throw new CWCoreException($"Failed to find in-play creature with id {id}")
        ;
        return result;
    }

    public InPlayCardState GetInPlayBuilding(string id) {
        var result = GetInPlayBuildingOrDefault(id)
            ?? throw new CWCoreException($"Failed to find in-play building with id {id}")
        ;
        return result;
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
                if (lane.Building is not null && lane.Building.Original.Card.ID == id)
                    return lane.Building;
        return null;
    }

    public InPlayCardState GetInPlayCard(string id) {
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                if (lane.Creature is not null && lane.Creature.Original.Card.ID == id)
                    return lane.Creature;
                if (lane.Building is not null && lane.Building.Original.Card.ID == id)
                    return lane.Building;
            }
        }
        throw new CWCoreException($"Failed to find in-play card with id {id}");
    }

    public async Task FloopCard(InPlayCardState card) {
        card.Original.Exhausted = true;
        // TODO? add update
    }

    public async Task Emit(string signal, Dictionary<string, object> args) {
        var logMessage = "Emitted signal " + signal + ", args: ";
        foreach (var pair in args) 
            logMessage += pair.Key + ":" + pair.Value.ToString() + " ";
        LogInfo(logMessage);

        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                var cards = new List<InPlayCardState>();
                if (lane.Creature is not null && lane.Creature.TriggeredEffects.Count > 0) {
                    cards.Add(lane.Creature);
                }
                if (lane.Building is not null && lane.Building.TriggeredEffects.Count > 0) {
                    cards.Add(lane.Building);
                }
                foreach (var card in cards) {
                    foreach (var trigger in card.TriggeredEffects) {
                        var on = trigger.Trigger;
                        if (on != signal) continue;

                        var canTrigger = trigger.ExecCheck(player, card, lane.Original.Idx);
                        if (!canTrigger) {
                            continue;
                        }

                        var payedCosts = trigger.ExecCosts(player, card, lane.Original.Idx);
                        if (!payedCosts) {
                            continue;
                        }

                        LogInfo($"Card {card.Original.Card.LogFriendlyName} triggers!");
                        trigger.ExecEffect(player, card, lane.Original.Idx);
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
        // TODO trigger
    }

    public async Task TurnLandscapeFaceUp(LandscapeState landscape) {
        if (!landscape.Original.FaceDown) {
            LogWarning($"Trying to flip a face-up landscape face-up");
            return;
        }
        
        landscape.Original.FaceDown = false;
        // TODO trigger
    }

    public async Task MoveCreature(string creatureId, int toI) {
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                var creature = lane.Creature;
                if (creature is null || creature.Original.Card.ID != creatureId) continue;

                var prevLaneI = lane.Original.Idx;
                if (prevLaneI == toI) {
                    ActionError($"Tried to move creature {creature.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}, which are the same");
                    return;
                }

                var newLane = player.Landscapes[toI];

                if (newLane.Original.Creature is not null)
                    throw new CWCoreException($"tried to move a creature to lane {toI}, which is not empty");
                    
                lane.Original.Creature = null;
                newLane.Original.Creature = creature.GetOriginal();
                creature.Original.MovementCount++;

                creature.Original.Card.ExecFunction(
                    InPlayCard.ON_MOVE_FNAME, 
                    creature.Original.Card.Data,
                    player.Original.Idx, 
                    prevLaneI,
                    toI
                );

                // TODO? add update
                // TODO trigger

                LogInfo($"Moved creature {creature.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}");
                return;
            }
        }
        throw new CWCoreException($"failed to find creature with id {creatureId} to move to lane {toI}");
    }

    public async Task MoveBuilding(string buildingId, int toI) {
        // TODO mostly repeated code from MoveCreature
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                var building = lane.Building;
                if (building is null || building.Original.Card.ID != buildingId) continue;

                var prevLaneI = lane.Original.Idx;
                if (prevLaneI == toI) {
                    ActionError($"Tried to move building {building.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}, which are the same");
                    return;
                }

                var newLane = player.Landscapes[toI];

                if (newLane.Original.Building is not null)
                    throw new CWCoreException($"tried to move a building to lane {toI}, which is not empty");
                    
                lane.Original.Building = null;
                newLane.Original.Building = building.Original;
                building.Original.MovementCount++;

                building.Original.Card.ExecFunction(
                    InPlayCard.ON_MOVE_FNAME,
                    building.Original.Card.Data,
                    player.Original.Idx, 
                    prevLaneI,
                    toI
                );

                // TODO? add update
                // TODO trigger

                LogInfo($"Moved building {building.Original.Card.LogFriendlyName} from lane {prevLaneI} to lane {toI}");
                return;
            }
        }
        throw new CWCoreException($"failed to find building with id {buildingId} to move to lane {toI}");
    }

    public async Task HealDamage(CreatureState creature, int amount) {
        var original = creature.GetOriginal();
        original.Damage -= amount;
        if (original.Damage < 0) original.Damage = 0;

        // TODO trigger
    }
}