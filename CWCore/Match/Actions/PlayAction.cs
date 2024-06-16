using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;

public class PlayAction : IAction
{
    // TODO change to "play"
    public string ActionWord() => "p";

    public async Task Exec(GameMatch match, int playerI, string[] args)
    {
        var cardId = args[1];
        var player = match.GetPlayerState(playerI);
        await player.PlayCard(cardId, false);
    }

    public IEnumerable<string> GetAvailable(GameMatch match, int playerI)
    {
        var player = match.GetPlayerState(playerI);
        foreach (var card in player.Hand) {
            if (!card.CanPlay(player)) continue; 
            var result = $"{ActionWord()} {card.Original.ID}";

            yield return result;
        }
    }
}
