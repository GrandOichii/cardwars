using CWCore.Match.States;

namespace CWCore.Match;

public class Creature : InPlayCard {
    public bool Attacking { get; set; } = false;

    public int Attack { get; }
    public int Defense { get; set; }

    public Creature(MatchCard card, int ownerI) : base(card, ownerI) {
        Attack = card.Template.Attack;
        Defense = card.Template.Defense;
    }

    public override void Ready()
    {
        base.Ready();
        
        Attacking = false;
    }

    public bool CanAttack() {
        // TODO add state-based effects
        return !Exhausted && !Attacking;
    }

}