using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match;

public class RestrictedActionPoint {
    private readonly LuaFunction _checkFunction;
    public RestrictedActionPoint(LuaFunction func) {
        _checkFunction = func;
    }

    public bool CanBeSpentOn(PlayerState player, CardState card, int? laneI = null) {
        return LuaUtility.GetReturnAsBool(_checkFunction.Call(card, laneI));
    }
}