using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;

public class DrawCardAction : IAction
{
    public string ActionWord() => "d";

    public async Task Exec(GameMatch match, int playerI, string[] args)
    {
        var player = match.GetPlayerState(playerI);
        var ap = player.Original.ActionPoints;

        if (ap < match.Config.CardDrawCost) {
            var errMsg = $"Player {player.Original.LogFriendlyName} tried to draw a card as an action, but failed (ap: {ap}, cost: {match.Config.CardDrawCost})";
            match.ActionError(errMsg);
            return;
        }

        player.PayActionPoints(match.Config.CardDrawCost);
        await player.Original.Draw(1);

        match.LogInfo($"Player {player.Original.LogFriendlyName} payed {match.Config.CardDrawCost} ap to draw a card. ({ap} -> {player.Original.ActionPoints})");

        return;
    }

    public IEnumerable<string> GetAvailable(GameMatch match, int playerI)
    {
        var player = match.GetPlayer(playerI);
        if (player.ActionPoints < match.Config.CardDrawCost) {
            yield break;
        }
        yield return ActionWord();
    }
}
