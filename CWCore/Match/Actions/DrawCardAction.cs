using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;

public class DrawCardAction : IAction
{
    public string ActionWord() => "draw";

    public Task Exec(GameMatch match, int playerI, string[] args)
    {
        var player = match.GetPlayer(playerI);
        var ap = player.ActionPoints;

        if (ap < match.Config.CardDrawCost) {
            var errMsg = $"Player {player.LogFriendlyName} tried to draw a card as an action, but failed (ap: {ap}, cost: {match.Config.CardDrawCost})";
            match.ActionError(errMsg);
            return Task.CompletedTask;
        }

        player.PayActionPoints(match.Config.CardDrawCost);
        player.Draw(1);

        match.LogInfo($"Player {player.LogFriendlyName} payed {match.Config.CardDrawCost} ap to draw a card. ({ap} -> {player.ActionPoints})");

        return Task.CompletedTask;
    }

    public IEnumerable<string> GetAvailable(GameMatch match, int playerI)
    {
        var player = match.GetPlayer(playerI);
        if (player.ActionPoints < match.Config.CardDrawCost) {
            return Enumerable.Empty<string>();
        }
        return new List<string>() { 
            ActionWord() 
        };
    }
}
