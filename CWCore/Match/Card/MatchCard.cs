using CWCore.Cards;
using CWCore.Match.Players;
using NLua;
using CWCore.Utility;
using CWCore.Match.States;
using CWCore.Exceptions;

namespace CWCore.Match;

public class MatchCard {
    public readonly static string CARD_CREATION_FNAME = "_Create";
    public readonly static string SPELL_EFFECT_FNAME = "Effect";

    public string ID { get; }
    public CardTemplate Template { get; }
    public LuaTable Data { get; }
    public int OwnerI { get; set; }

    // * for testing purposes
    public MatchCard(string id, CardTemplate template) {
        ID = id;
        Template = template;
    }

    public MatchCard(CardTemplate card, int ownerI, Lua state, IIDGenerator generator) {
        Template = card;
        OwnerI = ownerI;

        ID = generator.Next();

        state.DoString(card.Script);
        var creationF = LuaUtility.GetGlobalF(state,  CARD_CREATION_FNAME);
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
        try {
            var f = LuaUtility.TableGet<LuaFunction>(Data, fName);
            return f.Call(args);
        } catch (Exception e) {
            throw new CWCoreException($"exception in function {fName} of card {Template.Name}", e);
        }
    }
}