using CWCore.Match;
using CWCore.Match.Players;

public class RandomPlayerController : IPlayerController
{
    private readonly Random _rnd;
    public RandomPlayerController(int seed) {
        _rnd = new Random(seed);
    }
    public Task<int> PickAttackLane(GameMatch match, Player player, List<int> options)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PickBuilding(GameMatch match, Player player, List<string> options, string hint)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int> PickCardInHand(GameMatch match, Player player, List<int> options, string hint)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PickCreature(GameMatch match, Player player, List<string> options, string hint)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int[]> PickLandscape(GameMatch match, Player player, List<int> options, List<int> opponentOptions, string hint)
    {
        if (options.Count > 0) {
            return Task.FromResult(new int[2] {
                0, options[_rnd.Next() % options.Count]
            });
        }
        return Task.FromResult(new int[2] {
            1, opponentOptions[_rnd.Next() % opponentOptions.Count]
        });
    }

    public Task<int> PickLane(GameMatch match, Player player, List<int> options, string hint)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int> PickLaneForBuilding(GameMatch match, Player player, List<int> options)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<int> PickLaneForCreature(GameMatch match, Player player, List<int> options)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PickOption(GameMatch match, Player player, List<string> options, string hint)
    {
        return Task.FromResult(options[_rnd.Next() % options.Count]);
    }

    public Task<string> PromptAction(GameMatch match, Player player, IEnumerable<string> options)
    {
        var result = 0;
        foreach (var _ in options) ++result;
        return Task.FromResult(options.ElementAt(_rnd.Next() % result));
    }

    public Task<List<string>> PromptLandscapePlacement(Player player, Dictionary<string, int> landscapeIndex)
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
