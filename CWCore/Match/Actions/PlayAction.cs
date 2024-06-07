using CWCore.Exceptions;
using CWCore.Match.Players;

namespace CWCore.Match.Actions;

public class PlayAction : IAction
{
    public string ActionWord() => "play";

    public async Task Exec(GameMatch match, Player player, string[] args)
    {
        var ap = player.ActionPoints;
        var cardId = args[1];
        var card = player.Hand.FirstOrDefault(card => card.ID == cardId);
        if (card is null) {
            var errMsg = $"Player {player.LogFriendlyName} tried to play a card with id {cardId}, which they don't have in their hand";
            match.ActionError(errMsg);
            return;
        }

        if (card.IsSpell) {
            if (!card.CanPlay(player)) {
                var errMsg = $"Player {player.LogFriendlyName} tried to play card {card.LogFriendlyName}, which they cant";
                match.ActionError(errMsg);
                return;
            }

            player.PayToPlay(card);
            player.RemoveFromHand(card);

            await player.PlaySpellEffect(card);

            player.AddToDiscard(card);
            return;
        }

        match.ActionError($"Casting non-spell cards is not yet implemented ({card.LogFriendlyName} in hand of player {player.LogFriendlyName})");

        return;
    }

    public IEnumerable<string> GetAvailable(GameMatch match, Player player)
    {
        foreach (var card in player.Hand) {
            if (!card.CanPlay(player)) continue; 
            var result = $"{ActionWord()} {card.ID}";

            if (!card.IsSpell) {
                // TODO
                continue;
            }

            yield return result;
        }
    }
}
