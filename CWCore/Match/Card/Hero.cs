using CWCore.Cards;
using CWCore.Match.Players;
using NLua;
using CWCore.Utility;
using CWCore.Match.States;
using CWCore.Exceptions;
using CWCore.Match.Effects;

namespace CWCore.Match;

public class Hero : IStateModifier {
    public readonly static string CARD_CREATION_FNAME = "_Create";
    private readonly static string MODIFY_STATE_IN_HAND_FNAME = "ModifyState";

    public HeroTemplate Template { get; }
    public LuaTable Data { get; }
    public int OwnerI { get; set; }

    public List<HeroActivatedEffect> ActivatedEffects { get; }
    public List<HeroTriggeredEffect> TriggeredEffects { get; }


    public Hero(HeroTemplate card, int ownerI, Lua state) {
        Template = card;
        OwnerI = ownerI;

        state.DoString(card.Script);
        var creationF = LuaUtility.GetGlobalF(state, CARD_CREATION_FNAME);
        var returned = creationF.Call();
        Data = LuaUtility.GetReturnAs<LuaTable>(returned);


        ActivatedEffects = new();
        var effects = LuaUtility.TableGet<LuaTable>(Data, "ActivatedEffects");
        foreach (var table in effects.Values) {
            var effect = new HeroActivatedEffect((LuaTable)table);
            ActivatedEffects.Add(effect);
        }

        TriggeredEffects = new();
        var triggers = LuaUtility.TableGet<LuaTable>(Data, "Triggers");
        foreach (var table in triggers.Values) {
            var trigger = new HeroTriggeredEffect((LuaTable)table);
            TriggeredEffects.Add(trigger);
        }
    }

    public string LogFriendlyName => $"{Template.Name} [{OwnerI}]";

    public object[] ExecFunction(string fName, params object[] args) {
        try {
            var f = LuaUtility.TableGet<LuaFunction>(Data, fName);
            return f.Call(args);
        } catch (Exception e) {
            throw new CWCoreException($"exception in function {fName} of hero card {LogFriendlyName}", e);
        }
    }

    public void Modify(ModificationLayer layer)
    {
        ExecFunction(MODIFY_STATE_IN_HAND_FNAME, Data, (int)layer, OwnerI);
    }
}