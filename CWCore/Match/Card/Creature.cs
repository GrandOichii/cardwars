namespace CWCore.Match;

public class Creature : InPlayCard {
    public bool Attacking { get; set; } = false;

    public override void Ready()
    {
        base.Ready();
        
        Attacking = false;
    }

    public bool CanAttack() {
        // TODO
        return true;
    }
}