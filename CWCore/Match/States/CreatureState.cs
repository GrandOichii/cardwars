using CWCore.Match.Players;

namespace CWCore.Match.States;

// Things that can modify state: in play creatures, in play buildings

public class CreatureState {
    public Creature Creature { get; }

    public int Attack { get; set; }
    public int Defense { get; set; }
    public bool CanAttack { get; set; }

    public CreatureState(Creature creature) {
        Creature = creature;

        Attack = creature.Attack;
        Defense = creature.Defense;
        CanAttack = creature.CanAttack();
    }
}