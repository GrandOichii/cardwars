using CWCore.Match.States;

namespace CWCore.Match;

public class Creature : InPlayCard {
    public readonly static string ON_ENTER_PLAY_FNAME = "OnEnter";
    
    public bool Attacking { get; set; } = false;

    public int Attack { get; }
    public int Defense { get; set; }
    public int Damage { get; set; }

    public Creature(MatchCard card, int ownerI) : base(card, ownerI) {
        Attack = card.Template.Attack;
        Defense = card.Template.Defense;
        Damage = 0;
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

    public bool IsFlooped() => Exhausted && !Attacking;

}