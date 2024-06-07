using NLua;
using Utility;

namespace CWCore.Cards;

public class CardTemplate {
    public required string Name { get; set; }
    public required string Type { get; set; }
    public required int Cost { get; set; }
    public int Attack { get; set; } = -1;
    public int Defense { get; set; } = -1;
    public required string Text { get; set; }
    public string Script { get; set; } = "";

    public LuaTable GetProps(Lua state) {
        var result = LuaUtility.CreateTable(state);
        
        result["name"] = Name;
        result["cost"] = Cost;
        result["type"] = Type;
        result["attack"] = Attack;
        result["defense"] = Defense;
        result["text"] = Text;

        return result;
    }
}