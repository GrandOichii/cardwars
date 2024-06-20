namespace CWCore.Match;

public class MatchInfo {
    public MatchConfig Config { get; set; }
    public int PlayerIdx { get; set; }

    public MatchInfo(GameMatch match, int playerI)
    {
        Config = match.Config;
        PlayerIdx = playerI;
    }
}