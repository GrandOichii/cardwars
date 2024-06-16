using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Abilities;

public class HeroTriggeredAbility : HeroActivatedAbility
{
    public string Trigger { get; }
    public HeroTriggeredAbility(LuaTable table) : base(table)
    {
        Trigger = LuaUtility.TableGet<string>(table, "trigger");
    }
}