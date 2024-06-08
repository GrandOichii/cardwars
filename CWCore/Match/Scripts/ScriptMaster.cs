using System.Linq.Expressions;
using System.Reflection;
using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Scripts;

public class ScriptMaster {
    private readonly GameMatch _match;
    public ScriptMaster(GameMatch match) {
        _match = match;

        // load all methods into the Lua state
        var type = typeof(ScriptMaster);
        foreach (var method in type.GetMethods())
        {
            if (method.GetCustomAttribute(typeof(LuaCommand)) is not null)
            {
                _match.LState[method.Name] = method.CreateDelegate(Expression.GetDelegateType(
                    (from parameter in method.GetParameters() select parameter.ParameterType)
                    .Concat(new[] { method.ReturnType })
                .ToArray()), this);
            }
        }
    }


    [LuaCommand]
    public void LogInfo(string msg) {
        _match.LogInfo(msg);
    }

    [LuaCommand]
    public string PlayerLogFriendlyName(int playerI) {
        return _match.GetPlayer(playerI).LogFriendlyName;
    }

    [LuaCommand]
    public int Draw(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        var result = player.Draw(amount);
        return result;
    }

    [LuaCommand]
    public int GetHandCount(int playerI) {
        var player = _match.GetPlayer(playerI);
        return player.Hand.Count;
    }

    [LuaCommand]    
    public int DealDamageToPlayer(int playerI, int amount) {
        // ! hope this words
        var dealt = _match.DealDamageToPlayer(playerI, amount)
            .GetAwaiter().GetResult();
        return dealt;
    }

    [LuaCommand]
    public LuaTable GetCreatures(int playerI) {
        var player = _match.GetPlayerState(playerI);

        var result = new List<object>();

        foreach (var lane in player.Landscapes) {
            if (lane.Creature is null) continue;

            result.Add(lane.Creature);
        }

        return LuaUtility.CreateTable(_match.LState, result);
    }

    [LuaCommand]
    public void DealDamageToCreature(string creatureId, int amount) {
        var creature = _match.GetInPlayCreature(creatureId);
        _match.DealDamageToCreature(creature.GetOriginal(), amount)
            .Wait();
        _match.CheckDeadCreatures()
            .Wait();
    }

    [LuaCommand]
    public List<LandscapeState> GetLanes(int playerI) {
        return _match.LastState.Players[playerI].Landscapes;
    }

    [LuaCommand]
    public void AddActionPoints(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        player.ActionPoints += amount;
        // TODO? add update
    }

    [LuaCommand]
    public void FloopCard(string id) {
        var card = _match.GetInPlayCard(id); 
        _match.FloopCard(card)
            .Wait();
    }

    [LuaCommand]
    public MatchState GetState() {
        return _match.LastState;
    }

    [LuaCommand]
    public LuaTable GetPlayers() {
        var result = new List<PlayerState>();

        foreach (var player in _match.LastState.Players)
            result.Add(player);

        return LuaUtility.CreateTable(_match.LState, result);
    }

    [LuaCommand]
    public int GetCurPlayerI() {
        return _match.CurPlayerI;
    }

    [LuaCommand]
    public PlayerState GetPlayer(int playerI) {
        return _match.GetPlayerState(playerI);
    }

    [LuaCommand]
    public void TurnLandscapeFaceDown(int playerI, int laneI) {
        var player = _match.GetPlayerState(playerI);
        var lane = player.Landscapes[laneI];
        _match.TurnLandscapeFaceDown(lane)
            .Wait();
    }

    [LuaCommand]
    public void TurnLandscapeFaceUp(int playerI, int laneI) {
        var player = _match.GetPlayerState(playerI);
        var lane = player.Landscapes[laneI];
        _match.TurnLandscapeFaceUp(lane)
            .Wait();
    }

    [LuaCommand]
    public int[] ChooseLane(int playerI, LuaTable optionsTable, LuaTable opponentOptionsTable, string hint) {
        var player = _match.GetPlayerState(playerI);

        var options = new List<int>();
        foreach (var v in optionsTable.Values)
            options.Add(Convert.ToInt32(v));

        var opponentOptions = new List<int>();
        foreach (var v in opponentOptionsTable.Values)
            opponentOptions.Add(Convert.ToInt32(v));


        var result = player.Original.PickLandscape(options, opponentOptions, hint)
            .GetAwaiter().GetResult();

        return result;
    }

}