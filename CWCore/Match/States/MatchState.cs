using NLua;

namespace CWCore.Match.States;

public class MatchState {
    private readonly static ModificationLayer[] STATE_MODIFICATION_LAYERS = new ModificationLayer[] {
        ModificationLayer.IN_PLAY_CARD_TYPE,
        ModificationLayer.ATK_AND_DEF,
    };

    public PlayerState[] Players { get; }
    public List<LuaFunction> UEOTEffects { get; }
    public int TurnCount { get; set; }

    public MatchState() {
        Players = Array.Empty<PlayerState>();
        UEOTEffects = new();
        TurnCount = -1;
    }

    public MatchState(GameMatch match) {
        Players = new PlayerState[2];
        UEOTEffects = new(match.UEOTEffects);
        for (int i = 0; i < 2; i++) {
            Players[i] = new PlayerState(match.Players[i]);
        }

        TurnCount = match.TurnCount;
    }

    public void Modify() {
        foreach (var layer in STATE_MODIFICATION_LAYERS) {
            foreach (var player in Players) {
                player.Modify(this, layer);
            }

            foreach (var effect in UEOTEffects) {
                effect.Call(this, (int)layer);
            }
        }
    }
}