using CWCore.Match;
using CWCore.Match.Players;

public class RandomPlayerController : IPlayerController
{
    private readonly Random _rnd;
    public RandomPlayerController(int seed) {
        _rnd = new Random(seed);
    }
    public Task<int> PickAttackLane(GameMatch match, int playerI, List<int> options)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PickBuilding(GameMatch match, int playerI, List<string> options, string hint)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int> PickCardInHand(GameMatch match, int playerI, List<int> options, string hint)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PickCreature(GameMatch match, int playerI, List<string> options, string hint)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int[]> PickLandscape(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        var player = match.GetPlayer(playerI);
        if (options.Count > 0) {
            return Task.FromResult(new int[2] {
                0, options[_rnd.Next() % options.Count]
            });
        }
        return Task.FromResult(new int[2] {
            1, opponentOptions[_rnd.Next() % opponentOptions.Count]
        });
    }

    public Task<int> PickLane(GameMatch match, int playerI, List<int> options, string hint)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int> PickLaneForBuilding(GameMatch match, int playerI, List<int> options)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int> PickLaneForCreature(GameMatch match, int playerI, List<int> options)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PickOption(GameMatch match, int playerI, List<string> options, string hint)
    {
        var player = match.GetPlayer(playerI);
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PromptAction(GameMatch match, int playerI, IEnumerable<string> options)
    {
        var player = match.GetPlayer(playerI);
        var result = 0;
        foreach (var _ in options) ++result;
        return Task.FromResult(options.ElementAt(_rnd.Next() % result));
    }

    public Task<List<string>> PromptLandscapePlacement(int playerI, Dictionary<string, int> landscapeIndex)
    {
        // TODO
        return Task.FromResult(new List<string>() {
            "Cornfield",
            "Useless Swamp",
            "Blue Plains",
            "Cornfield"
        });
    }
}
