using CWCore.Match.Players;
using HexCore.GameMatch.Effects;

namespace CWCore.Match.States;

public class InPlayCardState : IStateModifier {
    public readonly static string MODIFY_STATE_FNAME = "ModifyState";

    public InPlayCard Original { get; }
    public int LaneI { get; }
    public List<ActivatedEffect> ActivatedEffects { get; set; }

    public InPlayCardState(InPlayCard original, int laneI) {
        Original = original;
        LaneI = laneI;

        ActivatedEffects = new();
        foreach (var effect in original.ActivatedEffects)
            ActivatedEffects.Add(effect);
    }

    public void Modify(MatchState state)
    {
        Original.Card.ExecFunction(MODIFY_STATE_FNAME, Original.Card.Data, state, this);
    }
}