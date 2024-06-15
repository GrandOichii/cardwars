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
        // TODO validate
        var laneI = int.Parse(args[1]);
        var player = match.GetPlayer(playerI);
        var landscape = player.Landscapes[laneI];

        var hasToken = landscape.HasToken("Frozen");

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
