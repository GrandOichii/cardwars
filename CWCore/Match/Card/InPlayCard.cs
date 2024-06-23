using CWCore.Match.States;
using CWCore.Utility;
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
    public List<ActivatedAbility> ActivatedAbilities { get; }
    public List<TriggeredAbility> TriggeredAbilities { get; }
    public List<LuaFunction> StateModifiers { get; }
    public List<LuaFunction> OnMoveEffects { get; }


    public InPlayCard(MatchCard card, int controllerI) {
        Card = card;
        ControllerI = controllerI;

        ActivatedAbilities = new();
        var abilities = LuaUtility.TableGet<LuaTable>(card.Data, "ActivatedAbilities");
        foreach (var table in abilities.Values) {
            var ability = new ActivatedAbility((LuaTable)table);
            ActivatedAbilities.Add(ability);
        }

        TriggeredAbilities = new();
        var triggers = LuaUtility.TableGet<LuaTable>(card.Data, "Triggers");
        foreach (var table in triggers.Values) {
            var trigger = new TriggeredAbility((LuaTable)table);
            TriggeredAbilities.Add(trigger);
        }

        StateModifiers = new();
        var modifiers = LuaUtility.TableGet<LuaTable>(card.Data, "StateModifiers");
        foreach (var modifier in modifiers.Values)
            StateModifiers.Add((LuaFunction)modifier);

        OnMoveEffects = new();
        var effects = LuaUtility.TableGet<LuaTable>(card.Data, "MoveEffects");
        foreach (var modifier in effects.Values)
            OnMoveEffects.Add((LuaFunction)modifier);
        
        EnteredThisTurn = true;
        MovementCount = 0;
    }

    public virtual void Ready() {
        Exhausted = false;
    }

    public virtual bool IsFlooped() => Exhausted;

    public bool CanFloop() {
        return !Exhausted;
    }

    public bool IsType(string type) {
        return Card.Template.Landscape == type;
    }

}