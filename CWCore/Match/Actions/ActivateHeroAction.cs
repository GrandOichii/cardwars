using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;


public class ActivateHeroAction : IAction
{
    // TODO change to "activatehero"
    public string ActionWord() => "ah";

    public async Task Exec(GameMatch match, int playerI, string[] args)
    {
        // TODO validate
        var abilityI = int.Parse(args[1]);

        var pState = match.GetPlayerState(playerI);
        var player = match.GetPlayer(playerI);
        var hero = player.Hero;

        if (hero is null) {
            match.ActionError($"Player tried to activate ability {abilityI} of hero card, which they don't have");
            return;
        }

        var effects = hero.ActivatedEffects;
        if (abilityI < 0 || abilityI >= effects.Count) {
            match.ActionError($"Player tried to activate ability {abilityI} of hero card {hero.LogFriendlyName}, which doesn't exist (card has {effects.Count} activated abilities)");
            return;
        }

        var effect = effects[abilityI];

        var canActivate = effect.CanActivate(pState);
        if (!canActivate) {
            match.ActionError($"Player {player.LogFriendlyName} tried to activate ability {abilityI} of card {hero.LogFriendlyName}, but failed check");
            return;
        }

        var payedCosts = effect.ExecCosts(pState);

        if (!payedCosts) {
            match.ActionError($"Player {player.LogFriendlyName} tried to activate ability {abilityI} of card {hero.LogFriendlyName}, but didn't pay activation costs");
            return;
        }

        match.LogInfo($"Player {player.LogFriendlyName} activated ability {abilityI} of card {hero.LogFriendlyName}");
        effect.ExecEffect(pState);
        effect.ActivatedThisTurn++;
    }

    public IEnumerable<string> GetAvailable(GameMatch match, int playerI)
    {
        var result = new List<string>();
        var pState = match.GetPlayerState(playerI);
        var hero = pState.Original.Hero;
        if (hero is null) return Enumerable.Empty<string>();

        for (int i = 0; i < hero.ActivatedEffects.Count; i++) {
            var effect = hero.ActivatedEffects[i];
            try {
                var canActivate = effect.CanActivate(pState);
                if (!canActivate) continue;

                result.Add($"{ActionWord()} {i}");
            } catch (Exception e) {
                throw new CWCoreException($"failed to activate check of ability {i} of hero card of player {match.Players[playerI].LogFriendlyName}", e);
            }
        }

        return result;
    }
}
