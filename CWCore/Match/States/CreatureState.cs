using CWCore.Match.Players;

namespace CWCore.Match.States;

// TODO add card in hand modification - Husker Knights need to display their ATK and DEF in hand

public class CreatureState : InPlayCardState {
    public int Attack { get; set; }
    public int Defense { get; set; }
    public bool CanAttack { get; set; }

    public int Damage { get; }

    public CreatureState(Creature creature, int laneI) : base(creature, laneI) {
        Attack = creature.Attack;
        Defense = creature.Defense;
        Damage = creature.Damage;
        CanAttack = creature.CanAttack();
    }
}