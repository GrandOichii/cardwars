using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Effects;

public class TriggeredEffect : ActivatedEffect
{
    public string Trigger { get; }
    public TriggeredEffect(LuaTable table) : base(table)
    {
        Trigger = LuaUtility.TableGet<string>(table, "trigger");
    }
}