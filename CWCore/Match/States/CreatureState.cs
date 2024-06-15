using CWCore.Match.Players;

namespace CWCore.Match.States;

// TODO add card in hand modification - Husker Knights need to display their ATK and DEF in hand

public class CreatureState : InPlayCardState {
    public int Attack { get; set; }
    public int Defense { get; set; }
    public bool CanAttack { get; set; }
    public int DamageMultiplier { get; set; }
    public bool AbsorbCreatureDamage { get; set; }

    public bool ProcessDealDamage { get; set; }

    public CreatureState(Creature creature, int laneI) : base(creature, laneI) {
        Attack = creature.Attack;
        Defense = creature.Defense;
        CanAttack = creature.CanAttack();

        DamageMultiplier = 1;
        AbsorbCreatureDamage = false;
        ProcessDealDamage = true;
    }

    // TODO? bad
    public int GetDamage() => GetOriginal().Damage;

    public Creature GetOriginal() => (Creature)Original;

    public void ProcessOnDealtDamage(int amount, string? creatureId) {
        if (!ProcessDealDamage) return;
        
        if (creatureId is null) {
            Original.Card.ExecFunction(
                Creature.ON_DEAL_DAMAGE_PLAY_FNAME, 
                Original.Card.Data,
                Original.ControllerI,
                LaneI,
                amount
            );
            return;
        }

        Original.Card.ExecFunction(
            Creature.ON_DEAL_DAMAGE_PLAY_FNAME, 
            Original.Card.Data,
            Original.ControllerI,
            LaneI,
            amount,
            creatureId
        );
    }
}