using CWCore.Match.Players;

namespace CWCore.Match.States;

public class PlayerState : IStateModifier {
    
    public List<LandscapeState> Landscapes { get; set; } = new();
    public PlayerState(Player player) {
        foreach (var lane in player.Landscapes) {
            Landscapes.Add(new(lane));
        }
    }
    
    public void Modify(MatchState state)
    {
        foreach (var lane in Landscapes) {
            lane.Modify(state);
        }
    }
}