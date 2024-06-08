using CWCore.Cards;
using CWCore.Decks;
using CWCore.Exceptions;
using CWCore.Match.Phases;
using CWCore.Match.Players;
using CWCore.Match.Scripts;
using CWCore.Match.States;
using Microsoft.Extensions.Logging;
using NLua;

namespace CWCore.Match;

public class GameMatch {
    private static readonly List<IPhase> _phases = new(){
        new TurnStartPhase(),
        new ActionPhase(),
        new BattlePhase(),
        // new TurnEnd()
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

    public GameMatch(MatchConfig config, ICardMaster cardMaster, string setupScript) {
        _cardMaster = cardMaster;
        Config = config;

        // TODO add seeding
        Rng = new();

        LogInfo("Running setup script");
        LState.DoString(setupScript);

        _scriptMaster = new(this);
        LastState = new();
    }

    public async Task AddPlayer(string name, DeckTemplate template, IPlayerController controller) {
        if (Players.Count == 2) {
            throw new GameMatchException("can't add player to match - already full");
        }
        
        var deck = await template.ToDeck(_cardMaster, LState, CardIDGenerator);
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
            var cPlayer = CurrentPlayer;

            LogInfo($"Player {cPlayer.LogFriendlyName} starts their turn");
            // Logger.ParseAndLog(cPlayer.Name + " started their turn.");

            foreach (var phase in _phases) {
                await phase.Exec(this, CurPlayerI);

                if (!Active) break;
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
        await PushUpdates();
        LastState = new(this);
    }

    public async Task DealDamageToCreature(Creature creature, int amount) {
        creature.Damage += amount;
        // TODO add update
        // TODO add trigger
        LogInfo($"{creature.Card.LogFriendlyName} is dealt {amount} damage");
    }

    public async Task CheckDeadCreatures() {
        foreach (var player in LastState.Players) {
            foreach (var lane in player.Landscapes) {
                var creature = lane.Creature;
                if (creature is null) continue;

                if (creature.Defense > creature.GetDamage()) continue;

                lane.Original.Creature = null;

                // TODO trigger pre-death triggers

                player.Original.AddToDiscard(creature.Original.Card);

                // TODO trigger death triggers

                LogInfo($"{creature.Original.Card.LogFriendlyName} in lane {creature.LaneI} dies!");
            }
        }
    }

    public CreatureState GetInPlayCreature(string id) {
        foreach (var player in LastState.Players)
            foreach (var lane in player.Landscapes)
                if (lane.Creature is not null && lane.Creature.Original.Card.ID == id)
                    return lane.Creature;
        throw new CWCoreException($"Failed to find in-play creature with id {id}");
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
}