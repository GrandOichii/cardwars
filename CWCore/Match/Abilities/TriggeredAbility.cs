using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Abilities;

public class TriggeredAbility : ActivatedAbility
{
    public string Trigger { get; }
    public TriggeredAbility(LuaTable table) : base(table)
    {
        Trigger = LuaUtility.TableGet<string>(table, "trigger");
    }
}