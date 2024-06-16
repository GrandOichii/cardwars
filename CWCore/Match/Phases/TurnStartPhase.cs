using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class TurnStartPhase : IPhase {
    public string GetName() => "turn_start";

    public Task PostEmit(GameMatch match, int playerI) {
        return Task.CompletedTask;
    }

    public async Task PreEmit(GameMatch match, int playerI)
    {
        var player = match.GetPlayer(playerI);
        await player.TurnStart();
    }
}