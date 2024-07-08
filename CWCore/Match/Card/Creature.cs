using CWCore.Match.States;

namespace CWCore.Match;

public class Creature : InPlayCard {
    public bool Attacking { get; set; } = false;

    public int Attack { get; }
    public int Defense { get; set; }
    public int Damage { get; set; }

    public List<LuaFunction> OnDealDamageEffects { get; }
    public List<LuaFunction> OnDamagedEffects { get; }
    public List<LuaFunction> OnAttackEffects { get; }
    public List<LuaFunction> OnDefeatedEffects { get; }

    public Creature(GameMatch match, MatchCard card, int controllerI) : base(match, card, controllerI) {
        Attack = card.Template.Attack;
        Defense = card.Template.Defense;
        Damage = 0;

        OnDealDamageEffects = new();
        var modifiers = LuaUtility.TableGet<LuaTable>(card.Data, "DealDamageEffects");
        foreach (var modifier in modifiers.Values)
            OnDealDamageEffects.Add((LuaFunction)modifier);

        OnDamagedEffects = new();
        var dEffects = LuaUtility.TableGet<LuaTable>(card.Data, "DamagedEffects");
        foreach (var effect in dEffects.Values)
            OnDamagedEffects.Add((LuaFunction)effect);

        OnAttackEffects = new();
        var aEffects = LuaUtility.TableGet<LuaTable>(card.Data, "AttackEffects");
        foreach (var effect in aEffects.Values)
            OnAttackEffects.Add((LuaFunction)effect);

        OnDefeatedEffects = new();
        var defEffects = LuaUtility.TableGet<LuaTable>(card.Data, "DefeatedEffects");
        foreach (var effect in defEffects.Values)
            OnDefeatedEffects.Add((LuaFunction)effect);
    }

    public override void Ready()
    {
        base.Ready();        
    }

    public bool CanAttack() {
        return CanFloop();
    }
}