namespace CWCore.Match.Players.Data;

public struct MatchData {
    public required string Request { get; set; }
    public required string Hint { get; set; }
    public required Dictionary<string, string> Args { get; set; }

    public List<PlayerData> Players { get; }
    public string PhaseName { get; }
    public int CurPlayerIdx { get; set; }
    public PersonalData Personal { get; set; }

    public MatchData(GameMatch match, int playerI) {
        PhaseName = match.PhaseName;
        CurPlayerIdx = match.CurPlayerI;

        Players = match.LastState.Players.Select(p => new PlayerData(p)).ToList();
        Personal = new(match, playerI);
    }
}