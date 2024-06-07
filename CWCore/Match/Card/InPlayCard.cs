namespace CWCore.Match;

public class InPlayCard {
    // TODO

    public bool EnteredThisTurn { get; set; }
    public bool Exhausted { get; set; }
    public int ControllerI { get; set; }

    public virtual void Ready() {
        Exhausted = false;
    }
}