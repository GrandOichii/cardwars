using CWCore.Match.Players;

namespace CWCore.Match.States;

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
        return !Original.FaceDown && GetName() == name;
    }

    public bool IsFrozen() => Original.Tokens.Contains("Frozen");

    public bool CanPlayBuilding(CardState building) {
        // TODO
        // return !IsFrozen();
        return true;
    }

    public bool CanPlayCreature(CardState creature) {
        // TODO
        // return !IsFrozen();
        return true;
    }

    public string GetName() {
        return Original.Name;
    }

    public void PreModify()
    {
    }
}