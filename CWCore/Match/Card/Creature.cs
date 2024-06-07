namespace CWCore.Match;

public class Creature : InPlayCard {
    public bool Attacking { get; set; } = false;

    public Creature(MatchCard card) : base(card) {
    }

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