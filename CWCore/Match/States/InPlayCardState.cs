namespace CWCore.Match.States;

public class InPlayCardState : IStateModifier {
    public InPlayCard Original { get; }
    public List<string> LandscapeTypes { get; }
    public int LaneI { get; }
    public List<ActivatedAbility> ActivatedAbilities { get; }
    public List<TriggeredAbility> TriggeredAbilities { get; }
    public List<LuaFunction> StateModifiers { get; }
    public List<string> CountsAsLandscapes { get; }

    public List<LuaFunction> CanBeTargetedCheckers { get; }

    public List<LuaFunction> OnMoveEffects { get; }
    public List<LuaFunction> OnEnterEffects { get; }
    public List<LuaFunction> OnLeaveEffects { get; }

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

        StateModifiers = new(original.StateModifiers);

        OnMoveEffects = new(original.OnMoveEffects);
        OnEnterEffects = new(original.OnEnterEffects);
        OnLeaveEffects = new(original.OnLeaveEffects);
        
        CountsAsLandscapes = new();
        LandscapeTypes = new() { Original.Card.Template.Landscape };
        CanBeTargetedCheckers = new();
    }

    public void Modify(ModificationLayer layer)
    {
        // TODO catch exception
        foreach (var mod in StateModifiers)
            mod.Call(
                this,
                (int)layer,
                "in_play"
            );
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

    public void OnEnterPlay(bool replaced) {
        foreach (var effect in OnEnterEffects)
            effect.Call(
                this, 
                Original.ControllerI, 
                LaneI, 
                replaced
            );
    }

    public void OnLeavePlay(LandscapeState from) {
        foreach (var effect in OnLeaveEffects)
            effect.Call(
                Original.ControllerI, 
                from.Original.Idx, 
                !Original.Exhausted
            );
    }

    public void PreModify()
    {
    }

    public bool CanBeTargetedBy(LuaTable sourceTable) {
        return CanBeTargetedCheckers.All(check => LuaUtility.GetReturnAsBool(check.Call(sourceTable)));
    }

    public void OnMove(int playerI, int prevLaneI, int newLaneI, bool wasStolen = false) {
        Original.MovementCount++;
        foreach (var effect in OnMoveEffects)
            effect.Call(
                playerI, 
                prevLaneI,
                newLaneI,
                wasStolen
            );
    }

}