using CWCore.Match.Players;

namespace CWCore.Match.States;

public class LandscapeState : IStateModifier {
    public Landscape Original { get; }
    public CreatureState? Creature { get; set; }
    public List<InPlayCardState> Buildings { get; set; }
    public List<int> CanFlipDown { get; set; }
    public int BuildingPlayLimit { get; set; }
    public string Name;

    public LandscapeState(PlayerState owner, Landscape landscape, int laneI) {
        Original = landscape;
        Name = Original.Name;
        BuildingPlayLimit = owner.Original.Match.Config.MaxBuildingsPerLane;
        
        if (landscape.Creature is not null) {
            Creature = new CreatureState(landscape.Creature, laneI);
        }

        Buildings = landscape.Buildings.Select(b => new InPlayCardState(b, laneI)).ToList();

        // TODO seems like a bad way to manage special abilities of tokens
        
        CanFlipDown = new() {
            0, 1
        };
    }

    public void Modify(ModificationLayer layer)
    {
        Creature?.Modify(layer);
        foreach (var b in Buildings)
            b.Modify(layer);   
    }

    public bool Is(string name) {
        return !Original.FaceDown && GetName() == name;
    }

    public bool IsFrozen() => Original.Tokens.Contains("Frozen");

    public bool CanPlayBuilding(CardState building) {
        return true;
        // return BuildingPlayLimit < 0 || Buildings.Count < BuildingPlayLimit;
    }

    public bool CanPlayCreature(CardState creature) {
        return true;
    }

    public string GetName() {
        return Name;
    }

    public void PreModify()
    {
    }
}