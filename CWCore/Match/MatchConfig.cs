namespace CWCore.Match;

public class MatchConfig {
    public required int StartingLifeTotal { get; set; }
    public required int ActionPointsPerTurn { get; set; }   
    public required int LaneCount { get; set; }
    public required bool StrictMode { get; set; }
    public required int CardDrawCost { get; set; }
    public required int StartHandSize { get; set; }
    public required bool CheckLandscapesForPlayingCards { get; set; }
    public required bool CanAttackOnFirstTurn { get; set; }
    public required bool CanFloopOnFirstTurn { get; set; }
}
