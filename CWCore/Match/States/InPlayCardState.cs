using CWCore.Match.Players;

namespace CWCore.Match.States;

public class InPlayCardState : IStateModifier {
    public readonly static string MODIFY_STATE_FNAME = "ModifyState";

    public InPlayCard Original { get; }
    public int LaneI { get; }

    public InPlayCardState(InPlayCard original, int laneI) {
        Original = original;
        LaneI = laneI;
    }

    public void Modify(MatchState state)
    {
        Original.Card.ExecFunction(MODIFY_STATE_FNAME, Original.Card.Data, state, this);
    }
}