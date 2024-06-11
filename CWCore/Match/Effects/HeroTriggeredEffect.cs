using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Effects;

public class HeroTriggeredEffect : HeroActivatedEffect
{
    public string Trigger { get; }
    public HeroTriggeredEffect(LuaTable table) : base(table)
    {
        Trigger = LuaUtility.TableGet<string>(table, "trigger");
    }
}