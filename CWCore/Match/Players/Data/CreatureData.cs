using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public class CreatureData : InPlayCardData {
    public int Attack { get; }
    public int Defense { get; }
    public bool Attacking { get; }
    public bool ExhaustedToAttack { get; }

    public CreatureData(CreatureState card) : base(card) {
        Attack = card.Attack;
        Defense = card.Defense;
        Attacking = card.GetOriginal().Attacking;
        ExhaustedToAttack = card.GetOriginal().ExhaustedToAttack;
    }
}