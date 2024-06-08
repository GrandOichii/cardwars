using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace HexCore.GameMatch.Effects;

public class ActivatedEffect {        
    public LuaFunction CheckF { get; }
    public LuaFunction CostF { get; }
    public LuaFunction EffectF { get; }

    public ActivatedEffect(LuaTable table) {
        CheckF = LuaUtility.TableGet<LuaFunction>(table, "checkF");
        CostF = LuaUtility.TableGet<LuaFunction>(table, "costF");
        EffectF = LuaUtility.TableGet<LuaFunction>(table, "effectF");
    }

    private static bool CheckFunction(LuaFunction f, Lua lState, PlayerState player, InPlayCardState state) {
        var returned = f.Call(state, player.Original.Idx);
        return LuaUtility.GetReturnAsBool(returned);
    }

    public bool ExecCheck(Lua lState, PlayerState player, InPlayCardState state) => CheckFunction(CheckF, lState, player, state);
    
    public bool ExecCosts(Lua lState, PlayerState player, InPlayCardState state) => CheckFunction(CostF, lState, player, state);

    public void ExecEffect(PlayerState player, InPlayCardState state) => EffectF.Call(state, player.Original.Idx);
}
