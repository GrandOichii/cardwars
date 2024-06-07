using System.Reflection;
using CWCore.Exceptions;
using CWCore.Match.Actions;
using CWCore.Match.Players;

namespace CWCore.Match.Phases;


[Serializable]
public class UnknownActionException : CWCoreException
{
    public UnknownActionException() : base() { }
    public UnknownActionException(string message) : base(message) { }
}

public class ActionPhase : IPhase {

    private static readonly List<IAction> ACTIONS = new() {
        new DrawCardAction(),
        new PlayAction(),
    };

    private static readonly Dictionary<string, IAction> ACTION_MAP = new(){};
    
    static ActionPhase() {
        foreach (var action in ACTIONS) {
            ACTION_MAP.Add(action.ActionWord(), action);
        }
    }

    public async Task Exec(GameMatch match, Player player) {
        string action;
        while (true)
        {
            action = await PromptAction(match, player);
            var words = action.Split(" ");

            var actionWord = words[0];

            if (actionWord == "battle") break;
            
            if (!ACTION_MAP.ContainsKey(actionWord)) {
                if (!match.Config.StrictMode) continue;
                throw new UnknownActionException("Unknown action from player " + player.Name + ": " + actionWord);
            }
            await ACTION_MAP[actionWord].Exec(match, player, words);
            await match.PushUpdates();
            if (!match.Active) break;   
        }
    }

    private static async Task<string> PromptAction(GameMatch match, Player player)
    {
        var options = new List<string>();
        foreach (var action in ACTION_MAP.Values) {
            options.AddRange(action.GetAvailable(match, player));
        }
        return await player.Controller.PromptAction(match, player, options);
    } 
}