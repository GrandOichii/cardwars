using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Effects;

public class ActivatedEffect {
    public LuaFunction CheckF { get; }
    public LuaFunction CostF { get; }
    public LuaFunction EffectF { get; }
    public int MaxActivationsPerTurn { get; }
    public int ActivatedThisTurn { get; set; }

    public ActivatedEffect(LuaTable table) {
        CheckF = LuaUtility.TableGet<LuaFunction>(table, "checkF");
        CostF = LuaUtility.TableGet<LuaFunction>(table, "costF");
        EffectF = LuaUtility.TableGet<LuaFunction>(table, "effectF");
        MaxActivationsPerTurn = Convert.ToInt32(table["maxActivationsPerTurn"]);

        ActivatedThisTurn = 0;
    }

    private static bool CheckFunction(LuaFunction f, PlayerState player, InPlayCardState state, int laneI, LuaTable? args) {
        
        return LuaUtility.GetReturnAsBool(
            args is not null
                ? f.Call(state, player.Original.Idx, laneI, args)
                : f.Call(state, player.Original.Idx, laneI)
        );
    }

    public bool ExecCheck(PlayerState player, InPlayCardState state, int laneI, LuaTable? args = null) => CheckFunction(CheckF, player, state, laneI, args);
    
    public bool ExecCosts(PlayerState player, InPlayCardState state, int laneI, LuaTable? args = null) => CheckFunction(CostF, player, state, laneI, args);

    public void ExecEffect(PlayerState player, InPlayCardState state, int laneI, LuaTable? args = null){
        if (args is not null) {
            EffectF.Call(state, player.Original.Idx, laneI, args);
            return;
        }
        EffectF.Call(state, player.Original.Idx, laneI);
    }

    public bool CanActivate(PlayerState player, InPlayCardState card, int laneI, LuaTable? args = null) {
        if (MaxActivationsPerTurn != -1 && ActivatedThisTurn >= MaxActivationsPerTurn) {
            return false;
        }
        return ExecCheck(player, card, laneI, args);
    }
}
