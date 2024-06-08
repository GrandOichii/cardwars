using CWCore.Match.Players;

namespace CWCore.Match.States;

public class PlayerState : IStateModifier {
    
    public List<LandscapeState> Landscapes { get; set; } = new();
    public PlayerState(Player player) {
        for (int i = 0; i < player.Landscapes.Count; i++) {
            Landscapes.Add(new(player.Landscapes[i], i));
        }
    }
    
    public void Modify(MatchState state)
    {
        foreach (var lane in Landscapes) {
            lane.Modify(state);
        }
    }
}