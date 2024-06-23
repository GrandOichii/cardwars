using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public readonly struct LandscapeData {
    public string Name { get; }
    public int Idx { get; }

    public CreatureData? Creature { get; }
    public List<InPlayCardData> Buildings { get; }

    public LandscapeData(LandscapeState landscape) {
        Name = landscape.Name;
    	Idx = landscape.Original.Idx;

        Creature = null;
        if (landscape.Creature is not null)
            Creature = new(landscape.Creature);
        Buildings = landscape.Buildings.Select(b => new InPlayCardData(b)).ToList();
    }
}
