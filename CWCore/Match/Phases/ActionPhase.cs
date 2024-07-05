using System.Reflection;
using CWCore.Exceptions;
using CWCore.Match.Actions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;


[Serializable]
public class UnknownActionException : GameMatchException
{
    public UnknownActionException() : base() { }
    public UnknownActionException(string message) : base(message) { }
}

public class ActionPhase : IPhase {
    private readonly static string FIGHT_ACTION = "f";

    private static readonly List<IAction> ACTIONS = new() {
        new DrawCardAction(),
        new PlayAction(),
        new ActivateAction(),
        new ActivateHeroAction(),
        new RemoveFrozenTokenAction(),
    };

    private static readonly Dictionary<string, IAction> ACTION_MAP = new(){};
    
    static ActionPhase() {
        foreach (var action in ACTIONS) {
            ACTION_MAP.Add(action.ActionWord(), action);
        }
    }

    public async Task PostEmit(GameMatch match, int playerI) {
        string action;
        var player = match.GetPlayer(playerI);

        while (true)
        {
            await match.ReloadState();
            if (!match.Active) return;
            
            action = await PromptAction(match, playerI);
            var words = action.Split(" ");

            var actionWord = words[0];

            if (actionWord == FIGHT_ACTION) break;
            
            if (!ACTION_MAP.ContainsKey(actionWord)) {
                if (!match.Config.StrictMode) continue;

                throw new UnknownActionException("Unknown action from player " + player.Name + ": " + actionWord);
            }

            await ACTION_MAP[actionWord].Exec(match, playerI, words);

            if (!match.Active) break;
        }
    }

    private static async Task<string> PromptAction(GameMatch match, int playerI)
    {
        var options = new List<string>();
        foreach (var action in ACTION_MAP.Values) {
            options.AddRange(action.GetAvailable(match, playerI));
        }
        
        if (options.Count == 0) return FIGHT_ACTION;
        var player = match.GetPlayer(playerI);
        return await player.Controller.PromptAction(match, player.Idx, options);
    }

    public string GetName() => "turn_action";
    public Task PreEmit(GameMatch match, int playerI)
    {
        return Task.CompletedTask;
    }
}