using CWCore.Match.States;

namespace CWCore.Match;

public class Creature : InPlayCard {
    public readonly static string ON_DEAL_DAMAGE_PLAY_FNAME = "OnDealDamage";

    public bool ExhaustedToAttack { get; set; } = false;
    public bool Attacking { get; set; } = false;

    public int Attack { get; }
    public int Defense { get; set; }
    public int Damage { get; set; }

    public Creature(MatchCard card, int controllerI) : base(card, controllerI) {
        Attack = card.Template.Attack;
        Defense = card.Template.Defense;
        Damage = 0;
    }

    public override void Ready()
    {
        base.Ready();
        
        ExhaustedToAttack = false;
    }

    public bool CanAttack() {
        return !Exhausted && !ExhaustedToAttack;
    }

    public override bool IsFlooped() {
        return Exhausted && !ExhaustedToAttack;
    }
}