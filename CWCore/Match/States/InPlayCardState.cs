using CWCore.Match.Players;
using NLua;

namespace CWCore.Match.States;

public class InPlayCardState : IStateModifier {
    public readonly static string MODIFY_STATE_FNAME = "ModifyState";

    public InPlayCard Original { get; }
    public List<string> LandscapeTypes { get; }
    public int LaneI { get; }
    public List<ActivatedAbility> ActivatedAbilities { get; }
    public List<TriggeredAbility> TriggeredAbilities { get; }
    public List<LuaFunction> StateModifiers { get; }
    public bool ProcessEnter { get; set; }
    public bool ProcessLeave { get; set; }
    public bool ProcessMove { get; set; }
    public List<int> CanBeTargetedBy { get; }
    public List<string> CountsAsLandscapes { get; }

    public InPlayCardState(InPlayCard original, int laneI) {
        Original = original;
        LaneI = laneI;

        ActivatedAbilities = new();
        foreach (var effect in original.ActivatedAbilities) {
            ActivatedAbilities.Add(effect);
            effect.Enabled = true;
        }

        TriggeredAbilities = new();
        foreach (var effect in original.TriggeredAbilities) {
            TriggeredAbilities.Add(effect);
            effect.Enabled = true;
        }

        StateModifiers = new();
        foreach (var modifier in original.StateModifiers)
            StateModifiers.Add(modifier);
        
        ProcessLeave = true;
        ProcessMove = true;
        ProcessEnter = true;
        CanBeTargetedBy = new() { 0, 1 };
        CountsAsLandscapes = new();
        LandscapeTypes = new() { Original.Card.Template.Landscape };
    }

    public void Modify(ModificationLayer layer)
    {
        Original.Card.ExecFunction(MODIFY_STATE_FNAME, Original.Card.Data, this, (int)layer, "in_play");
    }

    public bool IsType(string type) {
        // TODO some cards effect this
        foreach (var t in LandscapeTypes)
            if (t == type)
                return true;
        return false;
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