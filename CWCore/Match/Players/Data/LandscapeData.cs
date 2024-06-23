using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public readonly struct LandscapeData {
    public string Name { get; }
    public int Idx { get; }

    public LandscapeData(LandscapeState landscape) {
        Name = landscape.Name;
    	Idx = landscape.Original.Idx;
    }
}
