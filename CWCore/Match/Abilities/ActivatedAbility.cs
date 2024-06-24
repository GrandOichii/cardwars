using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Abilities;

public class ActivatedAbility {
    public string Text { get; }
    public List<string> Tags { get; }
    public LuaFunction CheckF { get; }
    public LuaFunction CostF { get; }
    public LuaFunction EffectF { get; }
    public int MaxActivationsPerTurn { get; }
    public int ActivatedThisTurn { get; set; }
    public bool Enabled { get; set; }

    public ActivatedAbility(LuaTable table) {
        Text = LuaUtility.TableGet<string>(table, "text");
        CheckF = LuaUtility.TableGet<LuaFunction>(table, "checkF");
        CostF = LuaUtility.TableGet<LuaFunction>(table, "costF");
        EffectF = LuaUtility.TableGet<LuaFunction>(table, "effectF");
        MaxActivationsPerTurn = Convert.ToInt32(table["maxActivationsPerTurn"]);

        Tags = new();
        var tagsTable = LuaUtility.TableGet<LuaTable>(table, "tags");
        foreach (var value in tagsTable.Values)
            Tags.Add((string)value);

        ActivatedThisTurn = 0;
        Enabled = true;
    }

    private static bool CheckFunction(LuaFunction f, PlayerState player, InPlayCardState state, int laneI, LuaTable? args) {
        try {
            return LuaUtility.GetReturnAsBool(
                args is not null
                    ? f.Call(state, player.Original.Idx, laneI, args)
                    : f.Call(state, player.Original.Idx, laneI)
            );
        } catch (Exception e) {
            throw new GameMatchException($"failed to execute ability check function of card {state.Original.Card.LogFriendlyName}", e);
        }
    }

    public bool ExecCheck(PlayerState player, InPlayCardState state, int laneI, LuaTable? args = null) => CheckFunction(CheckF, player, state, laneI, args);
    
    public bool ExecCosts(PlayerState player, InPlayCardState state, int laneI, LuaTable? args = null) => CheckFunction(CostF, player, state, laneI, args);

    public void ExecEffect(PlayerState player, InPlayCardState state, int laneI, LuaTable? args = null){
        try {
            if (args is not null) {
                EffectF.Call(state, player.Original.Idx, laneI, args);
                return;
            }
            EffectF.Call(state, player.Original.Idx, laneI);
        } catch (Exception e) {
            throw new GameMatchException($"failed to execute ability effect function of card {state.Original.Card.LogFriendlyName}", e);
        }
    }

    public bool CanActivate(PlayerState player, InPlayCardState card, int laneI, LuaTable? args = null) {
        if (!Enabled) return false;
        
        if (MaxActivationsPerTurn != -1 && ActivatedThisTurn >= MaxActivationsPerTurn) {
            return false;
        }
        return ExecCheck(player, card, laneI, args);
    }

    public bool HasTag(string tag) {
        return Tags.Contains(tag);
    }
}
