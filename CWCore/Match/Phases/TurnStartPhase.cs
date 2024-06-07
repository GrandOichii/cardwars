using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class TurnStartPhase : IPhase {
    public async Task Exec(GameMatch match, Player player, PlayerState playerState) {

        player.ActionPoints = match.Config.ActionPointsPerTurn;
        await player.ResetActionPoints();
        await player.ReadyInPlayCards();
        player.Draw(1);

        await match.PushUpdates();
    }
}