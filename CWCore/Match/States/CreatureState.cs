using CWCore.Match.Players;
using NLua;

namespace CWCore.Match.States;

public class CreatureState : InPlayCardState {
    private readonly static string ON_ATTACK_FNAME = "OnAttack";
    private readonly static string ON_DAMAGED_FNAME = "OnDamaged";
    private readonly static string ON_DEFEATED_FNAME = "OnDefeated";
    
    public int Attack { get; set; }
    public int Defense { get; set; }
    public bool CanAttack { get; set; }
    public int DamageMultiplier { get; set; }

    public bool ProcessDealDamage { get; set; }
    public bool ProcessDamaged { get; set; }
    public bool ProcessAttack { get; set; }
    public bool ProcessDefeated { get; set; }

    public bool IgnoreBlocker { get; set; }

    public List<LuaFunction> DamageModifiers { get; }

    public CreatureState(Creature creature, int laneI) : base(creature, laneI) {
        Attack = creature.Attack;
        Defense = creature.Defense;
        CanAttack = creature.CanAttack();

        DamageMultiplier = 1;
        ProcessDealDamage = true;
        ProcessDamaged = true;
        ProcessDefeated = true;
        DamageModifiers = new();
        IgnoreBlocker = false;
    }

    public bool ShouldDie() => Defense <= GetDamage();

    public int GetDamage() => GetOriginal().Damage;

    public Creature GetOriginal() => (Creature)Original;

    public void OnDefeated(Creature original) {
        if (!ProcessDefeated) return;

        Original.Card.ExecFunction(
            ON_DEFEATED_FNAME,
            Original.Card.Data,
            Original.ControllerI,
            LaneI,
            original
        );
    }

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

    public int CalcDamage(int initial, LuaTable from) {
        var result = initial;

        foreach (var mod in DamageModifiers) {
            result = Convert.ToInt32(LuaUtility.GetReturnAs<object>(mod.Call(this, from, result)));
        }

        return result;
    }
}