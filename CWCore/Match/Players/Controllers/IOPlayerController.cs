using System.Text.Json;
using CWCore.Match.Players.Data;

namespace CWCore.Match.Players.Controllers;

public interface IIOHandler {
    public Task<string> Read();
    public Task Write(string msg);
}

public class IOPlayerController : IPlayerController
{
    private readonly IIOHandler _handler;

    public IOPlayerController(IIOHandler handler) {
        _handler = handler;
    }

    private async Task WriteData(MatchData data) {
        var json = JsonSerializer.Serialize(data);
        await _handler.Write(json);
    }

    private static Dictionary<string, string> OptionsToDict<T>(List<T> options) {
        return options.Select((o, i) => new {o, i}).ToDictionary(e => e.i.ToString(), e => e.o!.ToString()!);
    }

    public async Task<int> PickAttackLane(GameMatch match, int playerI, List<int> options)
    {
        await WriteData(new(match, playerI) {
            Request = "PickAttackLane",
            Hint = "Activate creature to attack",
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return int.Parse(result);
    }

    public async Task<string> PickBuilding(GameMatch match, int playerI, List<string> options, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickBuilding",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return result;
    }

    public async Task<int> PickCard(GameMatch match, int playerI, List<string> options, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickCard",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return int.Parse(result);
    }

    public async Task<int[]> PickCardInDiscard(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickCardInDiscard",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        var split = result.Split(" ");

        return new int[] {
            int.Parse(split[0]),
            int.Parse(split[1]),
        };
    }

    public async Task<int> PickCardInHand(GameMatch match, int playerI, List<int> options, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickCardInHand",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return int.Parse(result);
    }

    public async Task<string> PickCreature(GameMatch match, int playerI, List<string> options, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickCreature",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return result;
    }

    public async Task<int[]> PickLandscape(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        var args = OptionsToDict(options);
        for (int i = 0; i < opponentOptions.Count; i++) {
            args.Add($"o{i}", opponentOptions[i].ToString());
        }

        await WriteData(new(match, playerI) {
            Request = "PickLandscape",
            Hint = hint,
            Args = args
        });

        var result = await _handler.Read();
        // TODO validate
        var split = result.Split(" ");

        return new int[] {
            int.Parse(split[0]),
            int.Parse(split[1]),
        };
    }

    public async Task<int> PickLane(GameMatch match, int playerI, List<int> options, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickLane",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return int.Parse(result);
    }

    public async Task<int> PickLaneForBuilding(GameMatch match, int playerI, List<int> options)
    {
        await WriteData(new(match, playerI) {
            Request = "PickLaneForBuilding",
            Hint = "Pick a landscape to place the building",
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return int.Parse(result);
    }

    public async Task<int> PickLaneForCreature(GameMatch match, int playerI, List<int> options)
    {
        await WriteData(new(match, playerI) {
            Request = "PickLaneForCreature",
            Hint = "Pick a landscape to place the creature",
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return int.Parse(result);
    }

    public async Task<string> PickOption(GameMatch match, int playerI, List<string> options, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickOption",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return result;
    }

    public async Task<int> PickPlayer(GameMatch match, int playerI, List<int> options, string hint)
    {
        await WriteData(new(match, playerI) {
            Request = "PickPlayer",
            Hint = hint,
            Args = OptionsToDict(options)
        });

        var result = await _handler.Read();
        // TODO validate
        return int.Parse(result);
    }

    public async Task<string> PromptAction(GameMatch match, int playerI, IEnumerable<string> options)
    {
        await WriteData(new(match, playerI) {
            Request = "PromptAction",
            Hint = "",
            Args = OptionsToDict(options.ToList())
        });

        var result = await _handler.Read();
        // TODO validate
        return result;
    }

    public async Task<List<string>> PromptLandscapePlacement(GameMatch match, int playerI, Dictionary<string, int> landscapeIndex)
    {
        System.Console.WriteLine(landscapeIndex.Count);
        await WriteData(new(match, playerI) {
            Request = "PromptLandscapePlacement",
            Hint = "Place your landscapes",
            Args = landscapeIndex.ToDictionary(pair => pair.Key, pair => pair.Value.ToString())
        });

        var result = await _handler.Read();
        // TODO validate
        return result.Split(" ").ToList();
    }

    public async Task Setup(GameMatch match, int playerI)
    {
        var info = new MatchInfo(match, playerI);
        var data = JsonSerializer.Serialize(info);
        await _handler.Write(data);
    }

    public async Task Update(GameMatch match, int playerI)
    {
        await WriteData(new(match, playerI) {
            Request = "Update",
            Hint = "",
            Args = new()
        });
    }
}