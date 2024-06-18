using CWCore.Match.Players;
using NLua;

namespace CWCore.Match.States;

public class CreatureState : InPlayCardState {
    private readonly static string ON_ATTACK_FNAME = "OnAttack";
    private readonly static string ON_DAMAGED_FNAME = "OnDamaged";
    
    public int Attack { get; set; }
    public int Defense { get; set; }
    public bool CanAttack { get; set; }
    public int DamageMultiplier { get; set; }
    public bool AbsorbCreatureDamage { get; set; }

    public bool ProcessDealDamage { get; set; }
    public bool ProcessDamaged { get; set; }
    public bool ProcessAttack { get; set; }

    public CreatureState(Creature creature, int laneI) : base(creature, laneI) {
        Attack = creature.Attack;
        Defense = creature.Defense;
        CanAttack = creature.CanAttack();

        DamageMultiplier = 1;
        AbsorbCreatureDamage = false;
        ProcessDealDamage = true;
        ProcessDamaged = true;
    }

    public int GetDamage() => GetOriginal().Damage;

    public Creature GetOriginal() => (Creature)Original;

    public void OnDealtDamage(int amount, string? toId) {
        if (!ProcessDealDamage) return;
        
        Original.Card.ExecFunction(
            Creature.ON_DEAL_DAMAGE_PLAY_FNAME, 
            Original.Card.Data,
            Original.ControllerI,
            LaneI,
            amount,
            toId
        );
    }

    public void OnDamaged(int amount, LuaTable sourceTable) {
        if (!ProcessDamaged) return;

        Original.Card.ExecFunction(
            ON_DAMAGED_FNAME,
            Original.Card.Data,
            this,
            Original.ControllerI,
            LaneI,
            amount,
            sourceTable
        );
    }

    public void OnAttack() {
        if (!ProcessAttack) return;
        Original.Card.ExecFunction(
            ON_ATTACK_FNAME, 
            Original.Card.Data,
            Original.ControllerI,
            LaneI
        );

    }
}