using CWCore.Match.Players;

namespace CWClient.v1;

public class TestPlayerController : IPlayerController
{
    private readonly IPlayerController _controller;
    private readonly int _timeout;

    public TestPlayerController(IPlayerController controller, int timeout) {
        _controller = controller;
        _timeout = timeout;
    }

    public async Task<int> PickAttackLane(GameMatch match, int playerI, List<int> options)
    {
        await Task.Delay(_timeout);
        return await _controller.PickAttackLane(match, playerI, options);
    }

    public async Task<string> PickBuilding(GameMatch match, int playerI, List<string> options, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickBuilding(match, playerI, options, hint);
    }

    public async Task<int> PickCard(GameMatch match, int playerI, List<string> options, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickCard(match, playerI, options, hint);
    }

    public async Task<int[]> PickCardInDiscard(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickCardInDiscard(match, playerI, options, opponentOptions, hint);
    }

    public async Task<int> PickCardInHand(GameMatch match, int playerI, List<int> options, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickCardInHand(match, playerI, options, hint);
    }

    public async Task<string> PickCreature(GameMatch match, int playerI, List<string> options, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickCreature(match, playerI, options, hint);
    }

    public async Task<int[]> PickLandscape(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickLandscape(match, playerI, options, opponentOptions, hint);
    }

    public async Task<int> PickLane(GameMatch match, int playerI, List<int> options, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickLane(match, playerI, options, hint);
    }

    public async Task<int> PickLaneForBuilding(GameMatch match, int playerI, List<int> options)
    {
        await Task.Delay(_timeout);
        return await _controller.PickLaneForBuilding(match, playerI, options);
    }

    public async Task<int> PickLaneForCreature(GameMatch match, int playerI, List<int> options)
    {
        await Task.Delay(_timeout);
        return await _controller.PickLaneForCreature(match, playerI, options);
    }

    public async Task<string> PickOption(GameMatch match, int playerI, List<string> options, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickOption(match, playerI, options, hint);
    }

    public async Task<int> PickPlayer(GameMatch match, int playerI, List<int> options, string hint)
    {
        await Task.Delay(_timeout);
        return await _controller.PickPlayer(match, playerI, options, hint);
    }

    public async Task<string> PromptAction(GameMatch match, int playerI, IEnumerable<string> options)
    {
        await Task.Delay(_timeout);
        return await _controller.PromptAction(match, playerI, options);
    }

    public async Task<List<string>> PromptLandscapePlacement(int playerI, Dictionary<string, int> landscapeIndex)
    {
        await Task.Delay(_timeout);
        return await _controller.PromptLandscapePlacement(playerI, landscapeIndex);
    }
}
