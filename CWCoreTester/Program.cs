using System.Security.Claims;
using System.Text.Json;
using System.Text.Json.Serialization;
using CWCore.Cards;
using CWCore.Decks;
using CWCore.Match;
using CWCore.Match.Players;
using Microsoft.Extensions.Logging;

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
    private void PrintInfo(GameMatch match, Player player) {
        foreach (var p in match.Players) {
            System.Console.WriteLine($"{p.LogFriendlyName} - {p.Life} {p.Hand.Count} [[{p.Deck.Count}]]");
        }
        System.Console.WriteLine("Lanes:");
        var landscapes = match.LastState.Players[player.Idx].Landscapes;
        
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

    public Task<int> PickAttackLane(GameMatch match, Player player, List<int> options)
    {
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

    public Task<int> PickLaneForCreature(GameMatch match, Player player)
    {
        PrintInfo(match, player);
        Console.Write("Pick lane for creature: ");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read lane idx for creature")
        ;
        return Task.FromResult(int.Parse(result));
    }

    public Task<string> PromptAction(GameMatch match, Player player, IEnumerable<string> options)
    {
        PrintInfo(match, player);
        System.Console.WriteLine("Hand:");
        foreach (var card in player.Hand)
            System.Console.WriteLine($"- {card.LogFriendlyName} <{card.Template.Cost}>");
        Console.WriteLine($"AP: {player.ActionPoints}");
        Console.WriteLine($"Available actions for {player.LogFriendlyName}:");
        foreach (var action in options)
            Console.WriteLine($"\t- {action}");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read action")
        ;
        return Task.FromResult(result);
    }

    public Task<List<string>> PromptLandscapePlacement(Player player, Dictionary<string, int> landscapeIndex)
    {
        return Task.FromResult(new List<string> {
            "Cornfield",
            "Blue Plains",
            "Cornfield",
            "Cornfield"
        });
    }

    public Task<int> PickLaneForBuilding(GameMatch match, Player player)
    {
        PrintInfo(match, player);
        Console.Write("Pick lane for building: ");
        var result = Console.ReadLine()
            ?? throw new Exception("failed to read lane idx for building")
        ;
        return Task.FromResult(int.Parse(result));
    }

    public Task<int> PickLane(GameMatch match, Player player, List<int> options, string hint)
    {
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

    public Task<int[]> PickLandscape(GameMatch match, Player player, List<int> options, List<int> opponentOptions, string hint)
    {
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

    public Task<string> PickCreature(GameMatch match, Player player, List<string> options, string hint)
    {
        
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

    public Task<string> PickOption(GameMatch match, Player player, List<string> options, string hint)
    {
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

    public Task<int> PickCardInHand(GameMatch match, Player player, List<int> options, string hint)
    {
        System.Console.WriteLine("Hand:");
        foreach (var card in player.Hand)
            System.Console.WriteLine($"- {card.LogFriendlyName} <{card.Template.Cost}>");
            
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

public class Program {
    public static async Task Main(string[] args) {
        try {
            var config = new MatchConfig() {
                StartingLifeTotal = 25,
                ActionPointsPerTurn = 12,
                LaneCount = 4,
                StrictMode = false,
                CardDrawCost = 1,
                StartHandSize = 5,
            };

            var cm = new FileCardMaster();
            cm.Load("../CWCore/cards");

            var deck1 = JsonSerializer.Deserialize<DeckTemplate>(File.ReadAllText("decks/deck1.json"))
                ?? throw new Exception("failed to read deck file")
            ;
            var deck2 = deck1;

            var controller1 = new ConsolePlayerController();
            var controller2 = controller1;

            var match = new GameMatch(config, cm, File.ReadAllText("../CWCore/core.lua"))
            {
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

    static void PrintException(Exception e) {
        var ex = e;
        while (ex is not null) {
            System.Console.WriteLine(ex.ToString());
            ex = ex.InnerException;
        }
    }
}