using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class TurnEndPhase : IPhase {
    public async Task Exec(GameMatch match, int playerI) {
        // TODO other stuff

        match.UEOTEffects.Clear();

        await match.ReloadState();
    }
}