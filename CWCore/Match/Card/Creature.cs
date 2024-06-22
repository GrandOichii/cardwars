using CWCore.Match.States;

namespace CWCore.Match;

public class Creature : InPlayCard {
    public bool ExhaustedToAttack { get; set; } = false;
    public bool Attacking { get; set; } = false;

    public int Attack { get; }
    public int Defense { get; set; }
    public int Damage { get; set; }

    public List<LuaFunction> OnDealDamageEffects { get; }

    public Creature(MatchCard card, int controllerI) : base(card, controllerI) {
        Attack = card.Template.Attack;
        Defense = card.Template.Defense;
        Damage = 0;

        OnDealDamageEffects = new();
        var modifiers = LuaUtility.TableGet<LuaTable>(card.Data, "DealDamageEffects");
        foreach (var modifier in modifiers.Values)
            OnDealDamageEffects.Add((LuaFunction)modifier);
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