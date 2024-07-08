using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match;


public enum InPlayCardStatus {
    READY = 0,
    EXHAUSTED,
    FLOOPED,
    ATTACKING
}


public class InPlayCard {
    public string IPID { get; }
    public MatchCard Card { get; }

    public bool EnteredThisTurn { get; set; }
    public int MovementCount { get; set; }

    public InPlayCardStatus Status { get; set; }
    public int ControllerI { get; set; }
    public List<ActivatedAbility> ActivatedAbilities { get; }
    public List<TriggeredAbility> TriggeredAbilities { get; }
    public List<LuaFunction> StateModifiers { get; }
    public List<LuaFunction> OnMoveEffects { get; }
    public List<LuaFunction> OnEnterEffects { get; }
    public List<LuaFunction> OnLeaveEffects { get; }

    public InPlayCard(GameMatch match, MatchCard card, int controllerI) {
        IPID = "ip" + match.CardIDGenerator.Next();
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
        var moveEffects = LuaUtility.TableGet<LuaTable>(card.Data, "MoveEffects");
        foreach (var modifier in moveEffects.Values)
            OnMoveEffects.Add((LuaFunction)modifier);

        OnEnterEffects = new();
        var enterEffects = LuaUtility.TableGet<LuaTable>(card.Data, "EnterEffects");
        foreach (var modifier in enterEffects.Values)
            OnEnterEffects.Add((LuaFunction)modifier);

        OnLeaveEffects = new();
        var leaveEffects = LuaUtility.TableGet<LuaTable>(card.Data, "LeaveEffects");
        foreach (var modifier in leaveEffects.Values)
            OnLeaveEffects.Add((LuaFunction)modifier);
        
        EnteredThisTurn = true;
        MovementCount = 0;
    }

    public int GetStatus() => (int)Status;

    public virtual void Ready() {
        Status = InPlayCardStatus.READY;
    }

    public bool IsFlooped() => Status == InPlayCardStatus.FLOOPED;

    public bool CanFloop() {
        return Status == InPlayCardStatus.READY;
    }

    public bool IsExhausted() => Status != InPlayCardStatus.READY;

    public bool IsType(string type) {
        return Card.Template.Landscape == type;
    }
}