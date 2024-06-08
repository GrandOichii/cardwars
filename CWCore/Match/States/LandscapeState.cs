using CWCore.Match.Players;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class LandscapeState : IStateModifier {
    public CreatureState? Creature { get; set; }
    public LandscapeState(Landscape landscape) {
        if (landscape.Creature is not null) {
            Creature = new CreatureState(landscape.Creature);
        }
        
        // TODO add building state
    }

    public void Modify(MatchState state)
    {
        Creature?.Modify(state);
        // TODO add building
    }
}