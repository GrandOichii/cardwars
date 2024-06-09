using NLua;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class MatchState {
    public PlayerState[] Players { get; }
    public List<LuaFunction> UEOTEffects { get; }

    public MatchState() {
        Players = Array.Empty<PlayerState>();
        UEOTEffects = new();
    }

    public MatchState(GameMatch match) {
        Players = new PlayerState[2];
        UEOTEffects = new(match.UEOTEffects);
        for (int i = 0; i < 2; i++) {
            Players[i] = new PlayerState(match.Players[i]);
        }
    }

    public void Modify() {
        foreach (var player in Players) {
            player.Modify(this);
        }

        foreach (var effect in UEOTEffects) {
            effect.Call(this);
        }
    }
}