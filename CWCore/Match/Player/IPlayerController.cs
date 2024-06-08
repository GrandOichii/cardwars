namespace CWCore.Match.Players;

public interface IPlayerController {
    // TODO
    public Task<string> PromptAction(GameMatch match, Player player, IEnumerable<string> options);
    public Task<List<string>> PromptLandscapePlacement(Player player, Dictionary<string, int> landscapeIndex);
    public Task<int> PickLaneForCreature(GameMatch match, Player player);
    public Task<int> PickLaneForBuilding(GameMatch match, Player player);
    public Task<int> PickAttackLane(GameMatch match, Player player, List<int> options);
    public Task<int> PickLane(GameMatch match, Player player, List<int> options, string hint);
    public Task<int[]> PickLandscape(GameMatch match, Player player, List<int> options, List<int> opponentOptions, string hint);
    public Task<string> PickCreature(GameMatch match, Player player, List<string> options, string hint);

}