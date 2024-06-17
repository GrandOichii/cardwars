using CWCore.Cards;
using CWCore.Match.Players;
using NLua;
using CWCore.Utility;
using CWCore.Match.States;
using CWCore.Exceptions;

namespace CWCore.Match;

public class Hero : IStateModifier {
    public readonly static string CARD_CREATION_FNAME = "_Create";
    private readonly static string MODIFY_STATE_IN_HAND_FNAME = "ModifyState";

    public HeroTemplate Template { get; }
    public LuaTable Data { get; }
    public int OwnerI { get; set; }

    public List<HeroActivatedAbility> ActivatedAbilities { get; }
    public List<HeroTriggeredAbility> TriggeredAbilities { get; }


    public Hero(HeroTemplate card, int ownerI, Lua state) {
        Template = card;
        OwnerI = ownerI;

        state.DoString(card.Script);
        var creationF = LuaUtility.GetGlobalF(state, CARD_CREATION_FNAME);
        var returned = creationF.Call();
        Data = LuaUtility.GetReturnAs<LuaTable>(returned);


        ActivatedAbilities = new();
        var abilities = LuaUtility.TableGet<LuaTable>(Data, "ActivatedAbilities");
        foreach (var table in abilities.Values) {
            var ability = new HeroActivatedAbility((LuaTable)table);
            ActivatedAbilities.Add(ability);
        }

        TriggeredAbilities = new();
        var triggers = LuaUtility.TableGet<LuaTable>(Data, "Triggers");
        foreach (var table in triggers.Values) {
            var trigger = new HeroTriggeredAbility((LuaTable)table);
            TriggeredAbilities.Add(trigger);
        }
    }

    public string LogFriendlyName => $"{Template.Name} [{OwnerI}]";

    public object[] ExecFunction(string fName, params object[] args) {
        try {
            var f = LuaUtility.TableGet<LuaFunction>(Data, fName);
            return f.Call(args);
        } catch (Exception e) {
            throw new GameMatchException($"exception in function {fName} of hero card {LogFriendlyName}", e);
        }
    }

    public void Modify(ModificationLayer layer)
    {
        ExecFunction(MODIFY_STATE_IN_HAND_FNAME, Data, (int)layer, OwnerI);
    }

    public void PreModify()
    {
    }
}