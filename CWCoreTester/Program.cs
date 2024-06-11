using System.Security.Claims;
using System.Text.Json;
using System.Text.Json.Serialization;
using CWCore.Cards;
using CWCore.Decks;
using CWCore.Match;
using CWCore.Match.States;
using CWCore.Match.Players;
using Microsoft.Extensions.Logging;
using Mindmagma.Curses;
using System.ComponentModel.Design;

public class FileCardMasterData {
    [JsonPropertyName("cards")]
    public required List<string> Cards { get; set; }
}

public class FileCardMaster : ICardMaster
{
    private readonly Dictionary<string, CardTemplate> _index = new();
    public void Load(string dir) {
        var manifestPath = Path.Join(dir, "manifest.json");
        var data = JsonSerializer.Deserialize<FileCardMasterData>(File.ReadAllText(manifestPath))
            ?? throw new Exception($"failed to deserialize json in {manifestPath}")
        ;
        foreach (var c in data.Cards) {
            var dataPath = Path.Join(dir, c);
            var card = JsonSerializer.Deserialize<CardTemplate>(File.ReadAllText(dataPath + ".json"))
                ?? throw new Exception($"failed to deserialize json in {dataPath}")
            ;
            var script = File.ReadAllText(dataPath + ".lua");
            card.Script = script;
            _index.Add(card.Name, card);
        }
    }

    public Task<CardTemplate> Get(string name)
    {
        return Task.FromResult(_index[name]);
    }
}

public class ConsolePlayerController : IPlayerController
{
    private void PrintInfo(GameMatch match, PlayerState player) {
        foreach (var p in match.Players) {
            System.Console.WriteLine($"{p.LogFriendlyName} - {p.Life} {p.Hand.Count} [[{p.Deck.Count}]] _{p.DiscardPile.Count}_");
        }
        System.Console.WriteLine("Lanes:");
        var landscapes = match.LastState.Players[player.Original.Idx].Landscapes;
        
        foreach (var lane in landscapes)
            System.Console.Write("|" + (lane.Original.Name + " " + (lane.Original.FaceDown ? "(FACEDOWN)" : "")).PadRight(40) + "|");
        System.Console.WriteLine();
        
        foreach (var lane in landscapes)
            System.Console.Write("|" + (lane.Creature is not null ? $"{lane.Creature.Original.Card.Template.Name}[{lane.Creature.Original.Card.ID}]({lane.Creature.CanAttack}) [{lane.Creature.Attack} / {lane.Creature.Defense - lane.Creature.GetDamage()}]" : "").PadRight(40) + "|");
        System.Console.WriteLine();
        foreach (var lane in landscapes)
            System.Console.Write("|" + (lane.Building is not null ? $"{lane.Building.Original.Card.Template.Name}[{lane.Building.Original.Card.ID}]" : "").PadRight(40) + "|");
        System.Console.WriteLine();
    }

    public Task<int> PickAttackLane(GameMatch match, int playerI, List<int> options)
    {
        var player = match.GetPlayerState(playerI);
        PrintInfo(match, player);
        System.Console.Write("Attack options: ");
        foreach (var option in options )
            System.Console.Write($"{option} ");
        System.Console.WriteLine();
        System.Console.Write("Pick attacker lane: ");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read attack lane idx")
        ;
        return Task.FromResult(int.Parse(result));
    }

    public Task<int> PickLaneForCreature(GameMatch match, int playerI, List<int> options)
    {
        var player = match.GetPlayerState(playerI);
        PrintInfo(match, player);
        System.Console.Write("Options: ");
        foreach (var option in options)
            System.Console.Write($"{option} ");
        System.Console.WriteLine();

        Console.Write("Pick lane for creature: ");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read lane idx for creature")
        ;
        return Task.FromResult(int.Parse(result));
    }

    public Task<string> PromptAction(GameMatch match, int playerI, IEnumerable<string> options)
    {
        var player = match.GetPlayerState(playerI);
        PrintInfo(match, player);
        System.Console.WriteLine("Hand:");
        foreach (var card in player.Hand)
            System.Console.WriteLine($"- {card.Original.LogFriendlyName} <{card.Cost}>");
        Console.WriteLine($"AP: {player.Original.ActionPoints}");
        Console.WriteLine($"Available actions for {player.Original.LogFriendlyName}:");
        foreach (var action in options)
            Console.WriteLine($"\t- {action}");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read action")
        ;
        return Task.FromResult(result);
    }

    public Task<List<string>> PromptLandscapePlacement(int playerI, Dictionary<string, int> landscapeIndex)
    {
        return Task.FromResult(new List<string> {
            "Cornfield",
            "Blue Plains",
            "Cornfield",
            "Cornfield"
        });
    }

    public Task<int> PickLaneForBuilding(GameMatch match, int playerI, List<int> options)
    {
        var player = match.GetPlayerState(playerI);
        PrintInfo(match, player);

        System.Console.Write("Options: ");
        foreach (var option in options)
            System.Console.Write($"{option} ");
        System.Console.WriteLine();

        Console.Write("Pick lane for building: ");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read lane idx for building")
        ;
        return Task.FromResult(int.Parse(result));
    }

    public Task<int> PickLane(GameMatch match, int playerI, List<int> options, string hint)
    {
        var player = match.GetPlayerState(playerI);
        System.Console.Write("Lanes: ");
        foreach (var option in options)
            System.Console.Write($"{option} ");
        System.Console.WriteLine();

        System.Console.WriteLine($"\"{hint}\"");
        System.Console.WriteLine("Choose landscape");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read landscape pair")
        ;

        return Task.FromResult(
            int.Parse(result)
        );
    }

    public Task<int[]> PickLandscape(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        var player = match.GetPlayerState(playerI);
         if (options.Count > 0) {
            System.Console.Write("Your landscapes: ");
            foreach (var option in options)
                System.Console.Write($"{option} ");
            System.Console.WriteLine();
        }
        if (opponentOptions.Count > 0) {
            System.Console.Write("Opponent's landscapes: ");
            foreach (var option in opponentOptions)
                System.Console.Write($"{option} ");
            System.Console.WriteLine();
        }

        System.Console.WriteLine($"\"{hint}\"");
        System.Console.WriteLine("Choose landscape");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read landscape pair")
        ;
        if (options.Count == 0) {
            return Task.FromResult(
                new int[2] {
                    1, int.Parse(result)
                }
            );
        }

        if (opponentOptions.Count == 0) {
            return Task.FromResult(
                new int[2] {
                    0, int.Parse(result)
                }
            );
        }

        var split = result.Split(" ");

        return Task.FromResult(
            new int[2] {
                int.Parse(split[0]),
                int.Parse(split[1]),
            }
        );
    }

    public Task<int[]> PickCardInDiscard(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        if (options.Count > 0) {
            System.Console.WriteLine("Your cards: ");
            foreach (var option in options)
                System.Console.WriteLine($"{option}: {match.LastState.Players[playerI].DiscardPile[option].Original.LogFriendlyName}");
            System.Console.WriteLine();
        }
        if (opponentOptions.Count > 0) {
            System.Console.WriteLine("Opponent's cards: ");
            foreach (var option in opponentOptions)
                System.Console.WriteLine($"{option}: {match.LastState.Players[1 - playerI].DiscardPile[option].Original.LogFriendlyName}");
            System.Console.WriteLine();
        }

        System.Console.WriteLine($"\"{hint}\"");
        System.Console.WriteLine("(Choose card in discard)");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read discard card idx")
        ;
        if (options.Count == 0) {
            return Task.FromResult(
                new int[2] {
                    1, int.Parse(result)
                }
            );
        }

        if (opponentOptions.Count == 0) {
            return Task.FromResult(
                new int[2] {
                    0, int.Parse(result)
                }
            );
        }

        var split = result.Split(" ");

        return Task.FromResult(
            new int[2] {
                int.Parse(split[0]),
                int.Parse(split[1]),
            }
        );
    }

    public Task<string> PickCreature(GameMatch match, int playerI, List<string> options, string hint)
    {
        var player = match.GetPlayerState(playerI);
        System.Console.Write("Options: ");
        foreach (var option in options)
            System.Console.Write($"{option} ");
        System.Console.WriteLine();

        System.Console.WriteLine($"\"{hint}\"");
        System.Console.WriteLine("(Choose in-play creature)");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read creature id")
        ;

        return Task.FromResult(result);
    }

    public Task<string> PickBuilding(GameMatch match, int playerI, List<string> options, string hint)
    {
        var player = match.GetPlayerState(playerI);
        System.Console.Write("Options: ");
        foreach (var option in options)
            System.Console.Write($"{option} ");
        System.Console.WriteLine();

        System.Console.WriteLine($"\"{hint}\"");
        System.Console.WriteLine("(Choose in-play building)");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read building id")
        ;

        return Task.FromResult(result);
    }

    public Task<string> PickOption(GameMatch match, int playerI, List<string> options, string hint)
    {
        var player = match.GetPlayerState(playerI);
        System.Console.WriteLine("Options: ");
        for (int i = 0; i < options.Count; i++)
            System.Console.WriteLine($"{i}: {options[i]}");

        System.Console.WriteLine($"\"{hint}\"");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read option")
        ;

        return Task.FromResult(
            options[int.Parse(result)]
        );
    }

    public Task<int> PickCardInHand(GameMatch match, int playerI, List<int> options, string hint)
    {
        var player = match.GetPlayerState(playerI);
        System.Console.WriteLine("Hand:");
        foreach (var card in player.Hand)
            System.Console.WriteLine($"- {card.Original.LogFriendlyName} <{card.Cost}>");
            
        System.Console.Write("Options: ");
        foreach (var option in options)
            System.Console.Write($"{option} ");
        System.Console.WriteLine();

        System.Console.WriteLine($"\"{hint}\"");
        System.Console.WriteLine("(Choose card in hand)");

        var result = Console.ReadLine()
            ?? throw new Exception("failed to read option")
        ;

        return Task.FromResult(
            int.Parse(result)
        );
    }
}

public class CursesPlayerController : IPlayerController
{
    private readonly RandomPlayerController _playerController;
    private readonly CursesView _view;
    public CursesPlayerController(int seed, CursesView view) {
        _view = view;
        _playerController = new RandomPlayerController(seed);
    }

    public void Wait() {
        var c = NCurses.GetChar();
        if (c == 'q') {
            throw new Exception("forced match end");
        }
    }

    public Task<int> PickAttackLane(GameMatch match, int playerI, List<int> options)
    {
        Wait();
        return _playerController.PickAttackLane(match, playerI, options);
    }

    public Task<string> PickBuilding(GameMatch match, int playerI, List<string> options, string hint)
    {
        Wait();
        return _playerController.PickBuilding(match, playerI, options, hint);
    }

    public Task<int> PickCardInHand(GameMatch match, int playerI, List<int> options, string hint)
    {
        Wait();
        return _playerController.PickCardInHand(match, playerI, options, hint);
    }

    public Task<string> PickCreature(GameMatch match, int playerI, List<string> options, string hint)
    {
        Wait();
        return _playerController.PickCreature(match, playerI, options, hint);
    }

    public Task<int[]> PickLandscape(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        Wait();
        return _playerController.PickLandscape(match, playerI, options, opponentOptions, hint);
    }

    public Task<int[]> PickCardInDiscard(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        Wait();
        return _playerController.PickLandscape(match, playerI, options, opponentOptions, hint);
    }

    public Task<int> PickLane(GameMatch match, int playerI, List<int> options, string hint)
    {
        Wait();
        return _playerController.PickLane(match, playerI, options, hint);
    }

    public Task<int> PickLaneForBuilding(GameMatch match, int playerI, List<int> options)
    {
        Wait();
        return _playerController.PickLaneForBuilding(match, playerI, options);
    }

    public Task<int> PickLaneForCreature(GameMatch match, int playerI, List<int> options)
    {
        Wait();
        return _playerController.PickLaneForCreature(match, playerI, options);
    }

    public Task<string> PickOption(GameMatch match, int playerI, List<string> options, string hint)
    {
        Wait();
        return _playerController.PickOption(match, playerI, options, hint);
    }

    public Task<string> PromptAction(GameMatch match, int playerI, IEnumerable<string> options)
    {
        Wait();
        return _playerController.PromptAction(match, playerI, options);
    }

    public Task<List<string>> PromptLandscapePlacement(int playerI, Dictionary<string, int> landscapeIndex)
    {
        Wait();
        return _playerController.PromptLandscapePlacement(playerI, landscapeIndex);
    }
}

public class CursesLogger : ILogger
{
    private readonly CursesView _view;
    public CursesLogger(CursesView view) {
        _view = view;
    }
    public IDisposable BeginScope<TState>(TState state) where TState : notnull => default!;

	// TODO
	public bool IsEnabled(LogLevel logLevel) => true;
		// getCurrentConfig().LogLevelToColorMap.ContainsKey(logLevel);



	public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
	{
		var log = formatter(state, exception);
        var logs = new List<string>();
        foreach (var l in CursesView.WordWrap(log, 50)) 
		_view.Logs.Add(l);
	}
}

public class Program {
    public static async Task TestRandom(int amount) {
         var config = new MatchConfig() {
            StartingLifeTotal = 25,
            ActionPointsPerTurn = 2,
            LaneCount = 4,
            StrictMode = true,
            CardDrawCost = 1,
            StartHandSize = 5,
            CheckLandscapesForPlayingCards = false,
            CanFloopOnFirstTurn = true,
            CanAttackOnFirstTurn = true,
        };

        var cm = new FileCardMaster();
        cm.Load("../CWCore/cards");

        var deck1 = JsonSerializer.Deserialize<DeckTemplate>(File.ReadAllText("decks/all.json"))
            ?? throw new Exception("failed to read deck file")
        ;
        var deck2 = deck1;

        int failed = 0;
        for (int i = 0; i < amount; i++) {
            System.Console.WriteLine("Seed: " + i);

            var controller1 = new RandomPlayerController(i);
            var controller2 = new RandomPlayerController(i);

            var match = new GameMatch(config, i, cm, File.ReadAllText("../CWCore/core.lua"))
            {
                // Logger = LoggerFactory
                //     .Create(builder => builder.AddConsole())
                //     .CreateLogger("Program")
            };

            await match.AddPlayer("player1", deck1, controller1);
            await match.AddPlayer("player2", deck2, controller2);

            // try {
                await match.Run();
        //     } catch (Exception e) {
        //         PrintException(e);
                
        //         ++failed;
        //     }
        }

        System.Console.WriteLine($"S/F: {amount - failed}/{amount}");
    }

    public static async Task SimpleConsole() {
        try {
            var seed = 0;
            var config = new MatchConfig() {
                StartingLifeTotal = 25,
                ActionPointsPerTurn = 20,
                LaneCount = 4,
                StrictMode = false,
                CardDrawCost = 1,
                StartHandSize = 5,
                CheckLandscapesForPlayingCards = false,
                CanFloopOnFirstTurn = true,
                CanAttackOnFirstTurn = true,
            };

            var cm = new FileCardMaster();
            cm.Load("../CWCore/cards");

            var deck1 = JsonSerializer.Deserialize<DeckTemplate>(File.ReadAllText("decks/deck1.json"))
                ?? throw new Exception("failed to read deck file")
            ;
            var deck2 = deck1;

            var controller1 = new ConsolePlayerController();
            var controller2 = controller1;

            var match = new GameMatch(config, seed, cm, File.ReadAllText("../CWCore/core.lua"))
            {
                // View = view,
                // Logger = new CursesLogger(view)
                Logger = LoggerFactory
                    .Create(builder => builder.AddConsole())
                    .CreateLogger("Program")
            };

            await match.AddPlayer("player1", deck1, controller1);
            await match.AddPlayer("player2", deck2, controller2);

            await match.Run();
        } catch (Exception e) {
            PrintException(e);
        }
    }

    public static async Task Main(string[] args) {

        await SimpleConsole();
        return;

        await TestRandom(100);
        return;

        var view = new CursesView();
        var seed = 5;
        try {
            var config = new MatchConfig() {
                StartingLifeTotal = 25,
                ActionPointsPerTurn = 2,
                LaneCount = 4,
                StrictMode = false,
                CardDrawCost = 1,
                StartHandSize = 5,
                CheckLandscapesForPlayingCards = false,
                CanFloopOnFirstTurn = false,
                CanAttackOnFirstTurn = false,
            };

            var cm = new FileCardMaster();
            cm.Load("../CWCore/cards");

            var deck1 = JsonSerializer.Deserialize<DeckTemplate>(File.ReadAllText("decks/deck1.json"))
                ?? throw new Exception("failed to read deck file")
            ;
            var deck2 = deck1;

            var controller1 = new CursesPlayerController(seed, view);
            var controller2 = controller1;

            var match = new GameMatch(config, seed, cm, File.ReadAllText("../CWCore/core.lua"))
            {
                View = view,
                Logger = new CursesLogger(view)
                // Logger = LoggerFactory
                //     .Create(builder => builder.AddConsole())
                //     .CreateLogger("Program")
            };

            await match.AddPlayer("player1", deck1, controller1);
            await match.AddPlayer("player2", deck2, controller2);

            await match.Run();
        } catch (Exception e) {
            await view.End();
            PrintException(e);
        }

    }

    static void PrintException(Exception e) {
        var ex = e;
        while (ex is not null) {
            System.Console.WriteLine(ex.ToString());
            ex = ex.InnerException;
        }
    }
}