using CWCore.Cards;
using CWCore.Match.Players;
using NLua;
using CWCore.Utility;
using CWCore.Match.States;

namespace CWCore.Match;

public class MatchCard {
    public readonly static string CARD_CREATION_FNAME = "_Create";
    public readonly static string SPELL_EFFECT_FNAME = "Effect";

    public string ID { get; }
    public CardTemplate Template { get; }
    public LuaTable Data { get; }

    public MatchCard(CardTemplate card, Lua state, IIDGenerator generator) {
        Template = card;

        ID = generator.Next();

        state.DoString(card.Script);
        var creationF = LuaUtility.GetGlobalF(state, CARD_CREATION_FNAME);
        var props = card.GetProps(state);
        var returned = creationF.Call(props);
        Data = LuaUtility.GetReturnAs<LuaTable>(returned);
        Data["id"] = ID;
    }

    public string LogFriendlyName => $"{Template.Name} [{ID}]";
    public bool IsSpell => Template.Type == "Spell";
    public bool IsCreature => Template.Type == "Creature";
    public bool IsBuilding => Template.Type == "Building";

    public object[] ExecFunction(string fName, params object[] args) {
        var f = LuaUtility.TableGet<LuaFunction>(Data, fName);
        return f.Call(args);
    }
}