using CWCore.Match;
using CWCore.Match.Players.Controllers;

public class RandomPlayerController : IPlayerController
{
    private readonly Random _rnd;
    private readonly int _delay;

    public RandomPlayerController(int seed, int delayMS = 0) {
        _rnd = new Random(seed);
        _delay = delayMS;
    }

    public async Task<int> PickAttackLane(GameMatch match, int playerI, List<int> options)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<string> PickBuilding(GameMatch match, int playerI, List<string> options, string hint)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<int> PickCardInHand(GameMatch match, int playerI, List<int> options, string hint)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<string> PickCreature(GameMatch match, int playerI, List<string> options, string hint)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<int[]> PickLandscape(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        if (options.Count > 0) {
            return new int[2] {
                0, options[_rnd.Next() % options.Count]
            };
        }
        return new int[2] {
            1, opponentOptions[_rnd.Next() % opponentOptions.Count]
        };
    }

    public async Task<int[]> PickCardInDiscard(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        if (options.Count > 0) {
            return new int[2] {
                0, options[_rnd.Next() % options.Count]
            };
        }
        return new int[2] {
            1, opponentOptions[_rnd.Next() % opponentOptions.Count]
        };
    }

    public async Task<int> PickLane(GameMatch match, int playerI, List<int> options, string hint)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<int> PickLaneForBuilding(GameMatch match, int playerI, List<int> options)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<int> PickLaneForCreature(GameMatch match, int playerI, List<int> options)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<string> PickOption(GameMatch match, int playerI, List<string> options, string hint)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        return options[_rnd.Next() % options.Count];
    }

    public async Task<string> PromptAction(GameMatch match, int playerI, IEnumerable<string> options)
    {
        await Task.Delay(_delay);
        var player = match.GetPlayer(playerI);
        var result = 0;
        foreach (var _ in options) ++result;
        return options.ElementAt(_rnd.Next() % result);
    }

    public async Task<int> PickCard(GameMatch match, int playerI, List<string> options, string hint) {
        var player = match.GetPlayer(playerI);
        await Task.Delay(_delay);
        return _rnd.Next() % options.Count;
    }

    public async Task<int> PickPlayer(GameMatch match, int playerI, List<int> options, string hint) {
        var player = match.GetPlayer(playerI);
        await Task.Delay(_delay);
        return _rnd.Next() % options.Count;
    }

    public async Task<List<string>> PromptLandscapePlacement(GameMatch match, int playerI, Dictionary<string, int> landscapeIndex)
    {
        await Task.Delay(_delay);
        // TODO
        return new List<string>() {
            "Cornfield",
            "Useless Swamp",
            "Blue Plains",
            "Cornfield"
        };
    }

    public async Task Setup(GameMatch match, int playerI)
    {
        await Task.Delay(_delay);
    }

    public async Task Update(GameMatch match, int playerI) { }
}
