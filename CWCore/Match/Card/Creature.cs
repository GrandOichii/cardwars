using CWCore.Match.States;

namespace CWCore.Match;

public class Creature : InPlayCard {
    public readonly static string MODIFY_STATE_FNAME = "MofidyState";
    public bool Attacking { get; set; } = false;

    public int Attack { get; }
    public int Defense { get; set; }

    public Creature(MatchCard card) : base(card) {
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

    public void ModifyState(MatchState state) {
        Card.ExecFunction(MODIFY_STATE_FNAME, Card.Data, state);
    }
}