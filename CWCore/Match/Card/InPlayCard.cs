using CWCore.Match.States;
using CWCore.Utility;
using CWCore.Match.Effects;
using NLua;

namespace CWCore.Match;

public class InPlayCard {
    public readonly static string ON_ENTER_PLAY_FNAME = "OnEnter";
    public readonly static string ON_LEAVE_PLAY_FNAME = "OnLeavePlay";

    public MatchCard Card { get; }

    // TODO utilize
    public bool EnteredThisTurn { get; set; }
    public int MovementCount { get; set; }

    public bool Exhausted { get; set; }
    public int ControllerI { get; set; }
    public int OwnerI { get; }
    public List<ActivatedEffect> ActivatedEffects { get; }
    public List<TriggeredEffect> TriggeredEffects { get; }

    public InPlayCard(MatchCard card, int ownerI) {
        Card = card;
        OwnerI = ownerI;

        ActivatedEffects = new();
        var effects = LuaUtility.TableGet<LuaTable>(card.Data, "ActivatedEffects");
        foreach (var table in effects.Values) {
            var effect = new ActivatedEffect((LuaTable)table);
            ActivatedEffects.Add(effect);
        }

        TriggeredEffects = new();
        var triggers = LuaUtility.TableGet<LuaTable>(card.Data, "Triggers");
        foreach (var table in triggers.Values) {
            var trigger = new TriggeredEffect((LuaTable)table);
            TriggeredEffects.Add(trigger);
        }
        
        EnteredThisTurn = true;
        MovementCount = 0;
    }

    public virtual void Ready() {
        Exhausted = false;
    }
}