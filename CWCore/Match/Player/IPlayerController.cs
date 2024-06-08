namespace CWCore.Match.Players;

public interface IPlayerController {
    // TODO
    public Task<string> PromptAction(GameMatch match, Player player, IEnumerable<string> options);
    public Task<List<string>> PromptLandscapePlacement(Player player, Dictionary<string, int> landscapeIndex);
    public Task<int> PickLaneForCreature(GameMatch match, Player player);
    public Task<int> PickAttackLane(GameMatch match, Player player, List<int> options);
}