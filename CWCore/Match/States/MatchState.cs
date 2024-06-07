namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class MatchState {
    public PlayerState[] Players { get; }

    public MatchState(GameMatch match) {
        Players = new PlayerState[2];
        for (int i = 0; i < 2; i++) {
            Players[i] = new PlayerState(match.Players[i]);
        }

    }
}