using CWCore.Exceptions;
using NLua;

namespace CWCore.Match.States;

public class MatchState {
    private readonly static ModificationLayer[] STATE_MODIFICATION_LAYERS = new ModificationLayer[] {
        ModificationLayer.ABILITY_GRANTING_REMOVAL,
        ModificationLayer.ADDITIONAL_LANDSCAPES,
        ModificationLayer.IN_PLAY_CARD_TYPE,
        ModificationLayer.LANDSCAPE_TYPE,
        ModificationLayer.LANDSCAPE_FLIP_DOWN_AVAILABILITY,

        ModificationLayer.IN_HAND_CARD_TYPE,
        ModificationLayer.CARD_COST,
        ModificationLayer.PLAY_RESTRICTIONS,
        ModificationLayer.ENTER_PLAY_STATE,

        ModificationLayer.ATK_AND_DEF,
        ModificationLayer.DAMAGE_MULTIPLICATION,
        ModificationLayer.TARGETING_PERMISSIONS,
        ModificationLayer.DAMAGE_MODIFICATION,
        ModificationLayer.ATTACK_RIGHTS,
        ModificationLayer.BUILDING_PLAY_LIMIT,
        ModificationLayer.READY_PRIVILEGES,
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
        foreach (var player in Players) {
            player.PreModify();
        }
        foreach (var layer in STATE_MODIFICATION_LAYERS) {
            foreach (var player in Players) {
                player.Modify(layer);
            }

            foreach (var effect in UEOTEffects) {
                try {
                    effect.Call((int)layer);
                } catch (Exception e) {
                    throw new GameMatchException($"failed to execute end of turn effect in layer {layer}", e);
                }
            }
        }
    }
}