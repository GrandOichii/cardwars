using CWCore.Match.Players;

namespace CWCore.Match.States;

public class PlayerState : IStateModifier {
    public Player Original { get; }
    public List<LandscapeState> Landscapes { get; set; } = new();
    public List<MatchCard> DiscardPile { get; set; } = new();
    public PlayerState(Player player) {
        Original = player;
        
        // landscapes
        for (int i = 0; i < player.Landscapes.Count; i++) {
            Landscapes.Add(new(player.Landscapes[i], i));
        }

        // discard
        foreach (var card in player.DiscardPile) {
            DiscardPile.Add(card);
        }
    }
    
    public void Modify(MatchState state)
    {
        foreach (var lane in Landscapes) {
            lane.Modify(state);
        }
    }
}