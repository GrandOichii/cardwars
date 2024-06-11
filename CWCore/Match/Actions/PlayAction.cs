using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;

public class PlayAction : IAction
{
    public string ActionWord() => "play";

    public async Task Exec(GameMatch match, int playerI, string[] args)
    {
        var playerState = match.GetPlayerState(playerI);
        var player = playerState.Original;
        var ap = player.ActionPoints;
        var cardId = args[1];
        var card = playerState.Hand.FirstOrDefault(card => card.Original.ID == cardId);
        if (card is null) {
            var errMsg = $"Player {player.LogFriendlyName} tried to play a card with id {cardId}, which they don't have in their hand";
            match.ActionError(errMsg);
            return;
        }

        if (!card.CanPlay(playerState)) {
            var errMsg = $"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName}, which they cant";
            match.ActionError(errMsg);
            return;
        }

        player.PayToPlay(card);
        player.RemoveFromHand(card.Original);

        if (card.Original.IsSpell) {
            await player.PlaySpellEffect(card.Original);

            player.AddToDiscard(card.Original);
            return;
        }

        if (card.Original.IsCreature) {
            var laneI = await playerState.PickLaneForCreature();

            if (laneI >= match.Config.LaneCount || laneI < 0) {
                var errMsg = $"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName} in lane {laneI}";
                throw new CWCoreException(errMsg);
            }

            await player.PlaceCreatureInLane(card.Original, laneI);

            return;
        }

        if (card.Original.IsBuilding) {
            var laneI = await playerState.PickLaneForBuilding();

            if (laneI >= match.Config.LaneCount || laneI < 0) {
                var errMsg = $"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName} in lane {laneI}";
                throw new CWCoreException(errMsg);
            }

            await player.PlaceBuildingInLane(card.Original, laneI);

            return;
        }

        throw new CWCoreException($"Unrecognized card type: {card.Original.Template.Type}");
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
