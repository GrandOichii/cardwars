namespace CWCore.Match;

public class InPlayCard {
    public MatchCard Card { get; }
    public bool EnteredThisTurn { get; set; }
    public bool Exhausted { get; set; }
    public int ControllerI { get; set; }

    public InPlayCard(MatchCard card) {
        Card = card;
    }

    public virtual void Ready() {
        Exhausted = false;
    }
}