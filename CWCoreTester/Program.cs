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
            System.Console.Write("|" + (lane.Creature is not null ? $"{lane.Creature.Original.Card.Template.Name}({lane.Creature.CanAttack}) [{lane.Creature.Attack} / {lane.Creature.Defense - lane.Creature.GetDamage()}]" : "").PadRight(30) + "|");
        System.Console.WriteLine();
        foreach (var lane in landscapes)
            System.Console.Write("|" + (lane.Building is not null ? $"{lane.Building.Original.Card.Template.Name}" : "").PadRight(30) + "|");
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
            "SandyLands",
            "Useless Swamp",
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
}

public class Program {
    public static async Task Main(string[] args) {
        var config = new MatchConfig() {
            StartingLifeTotal = 25,
            ActionPointsPerTurn = 2,
            LaneCount = 4,
            StrictMode = false,
            CardDrawCost = 1,
            StartHandSize = 1,
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
    }
}