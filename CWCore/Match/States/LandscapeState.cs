using CWCore.Match.Players;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class LandscapeState {
    public CreatureState? Creature { get; set; }
    public LandscapeState(Landscape landscape) {
        if (landscape.Creature is not null) {
            Creature = new CreatureState(landscape.Creature);
        }
        
        // TODO add building state
    }
}