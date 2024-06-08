using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class TurnStartPhase : IPhase {
    public async Task Exec(GameMatch match, int playerI) {
        var player = match.GetPlayer(playerI);

        player.ActionPoints = match.Config.ActionPointsPerTurn;
        await player.ResetActionPoints();
        await player.ReadyInPlayCards();

        await match.Emit("turn_start", new(){ {"playerI", playerI} });

        player.Draw(1);

        await match.ReloadState();
    }
}