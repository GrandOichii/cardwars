using NLua;
using CWCore.Utility;

namespace CWCore.Cards;

public class HeroTemplate {
    public required string Name { get; set; }
    public required string Text { get; set; }
    public string Script { get; set; } = "";

    public virtual LuaTable GetProps(Lua state) {
        var result = LuaUtility.CreateTable(state);
        
        result["name"] = Name;
        result["text"] = Text;

        return result;
    }
}