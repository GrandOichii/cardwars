using CWCore.Match.States;
using CWCore.Utility;
using CWCore.Match.Effects;
using NLua;

namespace CWCore.Match;

public class InPlayCard {
    public readonly static string ON_ENTER_PLAY_FNAME = "OnEnter";
    public readonly static string ON_LEAVE_PLAY_FNAME = "OnLeavePlay";
    public readonly static string ON_MOVE_FNAME = "OnMove";

    public MatchCard Card { get; }

    public bool EnteredThisTurn { get; set; }
    public int MovementCount { get; set; }

    public bool Exhausted { get; set; }
    public int ControllerI { get; set; }
    public List<ActivatedEffect> ActivatedEffects { get; }
    public List<TriggeredEffect> TriggeredEffects { get; }
    public List<LuaFunction> StateModifiers { get; }

    public InPlayCard(MatchCard card, int controllerI) {
        Card = card;
        ControllerI = controllerI;

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

        StateModifiers = new();
        var modifiers = LuaUtility.TableGet<LuaTable>(card.Data, "StateModifiers");
        // TODO feels bad
        foreach (var modifier in modifiers.Values)
            StateModifiers.Add((LuaFunction)modifier);
        
        EnteredThisTurn = true;
        MovementCount = 0;
    }

    public virtual void Ready() {
        Exhausted = false;
    }

    public virtual bool IsFlooped() => Exhausted;

    public void ProcessMove(int playerI, int prevLaneI, int newLaneI, bool wasStolen = false) {
        MovementCount++;

        Card.ExecFunction(
            ON_MOVE_FNAME, 
            Card.Data,
            playerI, 
            prevLaneI,
            newLaneI,
            wasStolen
        );
    }

    public bool IsType(string type) {
        return Card.Template.Landscape == type;
    }
}