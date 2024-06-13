using CWCore.Match.Players;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class LandscapeState : IStateModifier {
    public Landscape Original { get; }
    public CreatureState? Creature { get; set; }
    public InPlayCardState? Building { get; set; }
    public List<int> CanFlipDown { get; set; }

    public LandscapeState(Landscape landscape, int laneI) {
        Original = landscape;
        
        if (landscape.Creature is not null) {
            Creature = new CreatureState(landscape.Creature, laneI);
        }

        if (landscape.Building is not null) {
            Building = new InPlayCardState(landscape.Building, laneI);
        }

        // TODO seems like a bad way to manage special abilities of tokens
        bool isFrozen = Original.Tokens.Contains("Frozen");
        
        CanPlayBuilding = !isFrozen;
        CanPlayCreature = !isFrozen;

        CanFlipDown = new() {
            0, 1
        };
    }

    public void Modify(ModificationLayer layer)
    {
        Creature?.Modify(layer);
        Building?.Modify(layer);
    }

    public bool Is(string name) {
        return !Original.FaceDown && Original.Name == name;
    }


    public bool CanPlayBuilding { get; set; }
    public bool CanPlayCreature { get; set; }
}