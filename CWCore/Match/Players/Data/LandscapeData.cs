using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public readonly struct LandscapeData {
    public string Name { get; }
    public LandscapeData(LandscapeState landscape) {
        Name = landscape.Name;
    }
}
