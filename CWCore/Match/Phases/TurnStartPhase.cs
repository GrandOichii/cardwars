using CWCore.Match.Players;

namespace CWCore.Match.Phases;

public class TurnStartPhase : IPhase {
    public async Task Exec(GameMatch match, Player player) {

        player.ActionPoints = match.Config.ActionPointsPerTurn;
        await player.ResetActionPoints();
        await player.ReadyInPlayCards();
        player.Draw(1);

        await match.PushUpdates();
    }
}