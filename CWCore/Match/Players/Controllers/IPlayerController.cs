namespace CWCore.Match.Players.Controllers;

public interface IPlayerController {
    public Task Setup(GameMatch match, int playerI);
    public Task<string> PromptAction(GameMatch match, int playerI, IEnumerable<string> options);
    public Task<List<string>> PromptLandscapePlacement(GameMatch match, int playerI, Dictionary<string, int> landscapeIndex);
    public Task<int> PickLaneForCreature(GameMatch match, int playerI, List<int> options);
    public Task<int> PickLaneForBuilding(GameMatch match, int playerI, List<int> options);
    public Task<int> PickAttackLane(GameMatch match, int playerI, List<int> options);
    public Task<int> PickLane(GameMatch match, int playerI, List<int> options, string hint);
    public Task<int[]> PickLandscape(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint);
    public Task<int[]> PickCardInDiscard(GameMatch match, int playerI, List<int> options, List<int> opponentOptions, string hint);
    public Task<string> PickCreature(GameMatch match, int playerI, List<string> options, string hint);
    public Task<string> PickBuilding(GameMatch match, int playerI, List<string> options, string hint);
    public Task<string> PickOption(GameMatch match, int playerI, List<string> options, string hint);
    public Task<int> PickCardInHand(GameMatch match, int playerI, List<int> options, string hint);
    public Task<int> PickCard(GameMatch match, int playerI, List<string> options, string hint);
    public Task<int> PickPlayer(GameMatch match, int playerI, List<int> options, string hint);

    public Task Update(GameMatch match, int playerI);
}