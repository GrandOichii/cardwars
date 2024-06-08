using CWCore.Match.Players;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class LandscapeState : IStateModifier {
    public Landscape Original { get; }
    public CreatureState? Creature { get; set; }
    public InPlayCardState? Building { get; set; }

    public LandscapeState(Landscape landscape, int laneI) {
        Original = landscape;
        
        if (landscape.Creature is not null) {
            Creature = new CreatureState(landscape.Creature, laneI);
        }

        if (landscape.Building is not null) {
            Building = new InPlayCardState(landscape.Building, laneI);
        }
    }

    public void Modify(MatchState state)
    {
        Creature?.Modify(state);
        Building?.Modify(state);
    }
}