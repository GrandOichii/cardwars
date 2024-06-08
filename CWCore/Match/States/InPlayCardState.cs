using CWCore.Match.Players;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class InPlayCardState : IStateModifier {
    public readonly static string MODIFY_STATE_FNAME = "ModifyState";

    public InPlayCard Original { get; }

    public InPlayCardState(InPlayCard original) {
        Original = original;
    }

    public void Modify(MatchState state)
    {
        Original.Card.ExecFunction(MODIFY_STATE_FNAME, Original.Card.Data, state, this);
    }
}