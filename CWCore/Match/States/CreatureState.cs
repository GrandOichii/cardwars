using CWCore.Match.Players;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class CreatureState : InPlayCardState {
    public int Attack { get; set; }
    public int Defense { get; set; }
    public bool CanAttack { get; set; }

    public CreatureState(Creature creature, int laneI) : base(creature, laneI) {
        Attack = creature.Attack;
        Defense = creature.Defense;
        CanAttack = creature.CanAttack();
    }
}