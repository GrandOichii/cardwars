using CWCore.Match.Players;
using CWCore.Match.Effects;
using NLua;

namespace CWCore.Match.States;

public class InPlayCardState : IStateModifier {
    public readonly static string MODIFY_STATE_FNAME = "ModifyState";

    public InPlayCard Original { get; }
    public int LaneI { get; }
    public List<ActivatedEffect> ActivatedEffects { get; }
    public List<TriggeredEffect> TriggeredEffects { get; }
    public List<LuaFunction> StateModifiers { get; }
    public bool ProcessEnter { get; set; }
    public bool ProcessLeave { get; set; }
    public bool ProcessMove { get; set; }

    public InPlayCardState(InPlayCard original, int laneI) {
        Original = original;
        LaneI = laneI;

        ActivatedEffects = new();
        foreach (var effect in original.ActivatedEffects)
            ActivatedEffects.Add(effect);

        TriggeredEffects = new();
        foreach (var effect in original.TriggeredEffects)
            TriggeredEffects.Add(effect);

        StateModifiers = new();
        foreach (var modifier in original.StateModifiers)
            StateModifiers.Add(modifier);
        
        ProcessLeave = true;
        ProcessMove = true;
        ProcessEnter = true;
    }

    public void Modify(ModificationLayer layer)
    {
        Original.Card.ExecFunction(MODIFY_STATE_FNAME, Original.Card.Data, this, (int)layer, "in_play");
    }

    public bool IsType(string type) {
        // TODO some cards effect this

        return Original.IsType(type);
    }

    public async Task ReturnToOwnersHand(GameMatch match) {
        var controller = match.GetPlayer(Original.ControllerI);;
        var owner = match.GetPlayer(Original.Card.OwnerI);
        var landscape = controller.Landscapes[LaneI];
        landscape.Creature = null;
        owner.Hand.Add(Original.Card);
        // TODO? add update
    }

}