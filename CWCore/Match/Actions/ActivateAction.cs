using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;


public class ActivateAction : IAction
{
    public string ActionWord() => "activate";

    public async Task Exec(GameMatch match, int playerI, string[] args)
    {
        // TODO validate
        var cardId = args[1];
        var abilityI = int.Parse(args[2]);

        var pState = match.GetPlayerState(playerI);
        var player = match.GetPlayer(playerI);

        var map = CardsWithAbilities(match, playerI);
        foreach (var pair in map) {
            var laneI = pair.Key;
            foreach (var card in pair.Value) {
                if (card.Original.Card.ID != cardId) continue;

                var effects = card.ActivatedEffects;
                if (abilityI < 0 || abilityI >= effects.Count) {
                    match.ActionError($"Player tried to activate ability {abilityI} of card {card.Original.Card.LogFriendlyName}, which doesn't exist (card has {effects.Count} activated abilities)");
                    return;
                }

                var effect = effects[abilityI];
                var canActivate = effect.ExecCheck(pState, card, laneI);
                if (!canActivate) {
                    match.ActionError($"Player {player.LogFriendlyName} tried to activate ability {abilityI} of card {card.Original.Card.LogFriendlyName}, but failed check");
                    return;
                }

                var payedCosts = effect.ExecCosts(pState, card, laneI);

                if (!payedCosts) {
                    match.ActionError($"Player {player.LogFriendlyName} tried to activate ability {abilityI} of card {card.Original.Card.LogFriendlyName}, but didn't pay activation costs");
                    return;
                }

                match.LogInfo($"Player {player.LogFriendlyName} activated ability {abilityI} of card {card.Original.Card.LogFriendlyName}");
                effect.ExecEffect(pState, card, laneI);

                return;

            }
        }

        match.ActionError($"Player tried to activate in-play card with id {cardId}, which doesn't exist");
    }

    public IEnumerable<string> GetAvailable(GameMatch match, int playerI)
    {
        var result = new List<string>();
        var pState = match.GetPlayerState(playerI);
        var map = CardsWithAbilities(match, playerI);
        foreach (var pair in map) {
            var laneI = pair.Key;
            foreach (var card in pair.Value) {
                for (int i = 0; i < card.ActivatedEffects.Count; i++) {
                    var effect = card.ActivatedEffects[i];
                    var canActivate = effect.ExecCheck(pState, card, laneI);
                    if (!canActivate) continue;

                    result.Add($"{ActionWord()} {card.Original.Card.ID} {i}");
                }
            }
        }

        return result;
    }

    private static Dictionary<int, List<InPlayCardState>> CardsWithAbilities(GameMatch match, int playerI) {
        var result = new Dictionary<int, List<InPlayCardState>>();

        var pState = match.GetPlayerState(playerI);
        foreach (var lane in pState.Landscapes) {
            var cards = new List<InPlayCardState>();
            if (lane.Creature is not null && lane.Creature.ActivatedEffects.Count > 0) {
                cards.Add(lane.Creature);
            }
            if (lane.Building is not null && lane.Building.ActivatedEffects.Count > 0) {
                cards.Add(lane.Building);
            }
            result.Add(lane.Original.Idx, cards);
        }

        return result;
    }

    
}
