using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Abilities;

public class HeroActivatedAbility {
    public LuaFunction CheckF { get; }
    public LuaFunction CostF { get; }
    public LuaFunction EffectF { get; }
    public int MaxActivationsPerTurn { get; }
    public int ActivatedThisTurn { get; set; }

    public HeroActivatedAbility(LuaTable table) {
        CheckF = LuaUtility.TableGet<LuaFunction>(table, "checkF");
        CostF = LuaUtility.TableGet<LuaFunction>(table, "costF");
        EffectF = LuaUtility.TableGet<LuaFunction>(table, "effectF");
        MaxActivationsPerTurn = Convert.ToInt32(table["maxActivationsPerTurn"]);

        ActivatedThisTurn = 0;
    }

    private static bool CheckFunction(LuaFunction f, PlayerState player, LuaTable? args) {
         try {
            return LuaUtility.GetReturnAsBool(
                args is not null
                    ? f.Call(player.Original.Idx, args)
                    : f.Call(player.Original.Idx)
            );
        } catch (Exception e) {
            throw new GameMatchException($"failed to execute check function of activated effect of hero card of player {player.Original.LogFriendlyName}", e);
        }
    }

    public bool ExecCheck(PlayerState player, LuaTable? args = null) => CheckFunction(CheckF, player, args);
    
    public bool ExecCosts(PlayerState player, LuaTable? args = null) => CheckFunction(CostF, player, args);

    public void ExecEffect(PlayerState player, LuaTable? args = null){
        try {
            if (args is not null) {
                EffectF.Call(player.Original.Idx, args);
                return;
            }
            EffectF.Call(player.Original.Idx);
        } catch (Exception e) {
            throw new GameMatchException($"failed to execute effect function of activated effect of hero card of player {player.Original.LogFriendlyName}", e);
        }
    }

    public bool CanActivate(PlayerState player, LuaTable? args = null) {
        if (MaxActivationsPerTurn != -1 && ActivatedThisTurn >= MaxActivationsPerTurn) {
            return false;
        }
        return ExecCheck(player, args);
    }
}
