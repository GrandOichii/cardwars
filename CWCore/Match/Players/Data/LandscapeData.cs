using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public readonly struct LandscapeData {
    public string Name { get; }
    public int Idx { get; }
    public bool FaceDown { get; }
    public List<string> Tokens { get; }

    public CreatureData? Creature { get; }
    public List<InPlayCardData> Buildings { get; }

    public LandscapeData(LandscapeState landscape) {
        Name = landscape.Name;
    	Idx = landscape.Original.Idx;
        FaceDown = landscape.Original.FaceDown;
        Tokens = new(landscape.Original.Tokens);

        Creature = null;
        if (landscape.Creature is not null)
            Creature = new(landscape.Creature);
        Buildings = landscape.Buildings.Select(b => new InPlayCardData(b)).ToList();
    }
}
