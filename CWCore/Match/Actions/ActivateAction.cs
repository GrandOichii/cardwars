using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;


public class ActivateAction : IAction
{
    // TODO change to "activate"
    public string ActionWord() => "a";

    public async Task Exec(GameMatch match, int playerI, string[] args)
    {
        // TODO validate
        var cardId = args[1];
        var abilityI = int.Parse(args[2]);

        var pState = match.GetPlayerState(playerI);
        var player = pState.Original;

        var card = pState.GetInPlayCard(cardId);
        var laneI = card.LaneI;
        var abilities = card.ActivatedAbilities;
    
        if (abilityI < 0 || abilityI >= abilities.Count) {
            match.ActionError($"Player tried to activate ability {abilityI} of card {card.Original.Card.LogFriendlyName}, which doesn't exist (card has {abilities.Count} activated abilities)");
            return;
        }

        var ability = abilities[abilityI];

        var canActivate = ability.CanActivate(pState, card, laneI);
        if (!canActivate) {
            match.ActionError($"Player {player.LogFriendlyName} tried to activate ability {abilityI} of card {card.Original.Card.LogFriendlyName}, but failed check");
            return;
        }

        var payedCosts = ability.ExecCosts(pState, card, laneI);

        if (!payedCosts) {
            match.ActionError($"Player {player.LogFriendlyName} tried to activate ability {abilityI} of card {card.Original.Card.LogFriendlyName}, but didn't pay activation costs");
            return;
        }

        match.LogInfo($"Player {player.LogFriendlyName} activated ability {abilityI} of card {card.Original.Card.LogFriendlyName}");
        ability.ExecEffect(pState, card, laneI);
        ability.ActivatedThisTurn++;

        return;
    }

    public IEnumerable<string> GetAvailable(GameMatch match, int playerI)
    {
        var result = new List<string>();
        var pState = match.GetPlayerState(playerI);
        var cards = CardsWithAbilities(match, playerI);
        foreach (var card in cards) {
            for (int i = 0; i < card.ActivatedAbilities.Count; i++) {
                var effect = card.ActivatedAbilities[i];
                try {
                    var canActivate = effect.CanActivate(pState, card, card.LaneI);
                    if (!canActivate) continue;

                    result.Add($"{ActionWord()} {card.Original.Card.ID} {i}");
                } catch (Exception e) {
                    throw new GameMatchException($"failed to activate check of ability {i} of card {card.Original.Card.Template.Name}", e);
                }
            }
        }
        return result;
    }

    private static List<InPlayCardState> CardsWithAbilities(GameMatch match, int playerI) {
        var player = match.GetPlayerState(playerI);
        var cards = player.GetInPlayCards();
        return cards.Where(c => c.ActivatedAbilities.Count > 0).ToList();
    }
}
