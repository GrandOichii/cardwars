using CWCore.Match.States;

namespace CWCore.Match;

public class InPlayCard {
    public MatchCard Card { get; }
    public bool EnteredThisTurn { get; set; }
    public bool Exhausted { get; set; }
    public int ControllerI { get; set; }
    public int OwnerI { get; }

    public InPlayCard(MatchCard card, int ownerI) {
        Card = card;
        OwnerI = ownerI;
    }

    public virtual void Ready() {
        Exhausted = false;
    }
}