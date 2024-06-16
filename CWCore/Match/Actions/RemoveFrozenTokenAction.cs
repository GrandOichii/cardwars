using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;

public class RemoveFrozenTokenAction : IAction
{
    // TODO change to "removefrozen"
    public string ActionWord() => "rf";

    public async Task Exec(GameMatch match, int playerI, string[] args)
    {
        var laneIRaw = args[1];
        var parced = int.TryParse(laneIRaw, out int laneI);
        if (!parced) {
            match.ActionError($"incorrect arguments for action {ActionWord()} - expected args[1] to be int, but found {laneIRaw}");
            return;
        }

        var player = match.GetPlayer(playerI);
        var landscape = player.Landscapes[laneI];

        var hasToken = landscape.HasToken("Frozen");
        if (!hasToken) {
            match.ActionError($"player {player.LogFriendlyName} tried to remove Frozen counter from lane {laneI}, where there is none");
            return;
        }

        var options = new List<int>();
        for (int i = 0; i < player.Hand.Count; i++) {
            options.Add(i);
        }

        var choice = await player.PickCardInHand(options, "Choose a card to discard (to remove Frozen token)");
        await player.DiscardCardFromHand(choice);

        var removed = landscape.RemoveToken("Frozen");
        if (!removed) {
            throw new CWCoreException($"tried to remove Frozen token from lane {laneI} of player {player.LogFriendlyName}, but failed");
        }
    }

    public IEnumerable<string> GetAvailable(GameMatch match, int playerI)
    {
        var player = match.GetPlayer(playerI);
        if (player.Hand.Count == 0) yield break;
        foreach (var landscape in player.Landscapes) {
            if (!landscape.HasToken("Frozen")) continue;

            yield return $"{ActionWord()} {landscape.Idx}";
        }
    }
}
