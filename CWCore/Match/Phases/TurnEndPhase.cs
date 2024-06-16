using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Exceptions;

namespace CWCore.Match.Phases;

public class TurnEndPhase : IPhase {
    public string GetName() => "turn_end";

    public async Task PostEmit(GameMatch match, int playerI) {
        // At the end of turn effects
        foreach (var trigger in match.AEOTEffects) {
            try {
                trigger.Call();
            } catch (Exception e) {
                throw new GameMatchException("error while executing \"at the end of turn\" effect", e);
            }
        }
        match.AEOTEffects.Clear();

        // Until the end of turn effects
        match.UEOTEffects.Clear();

        // Players
        foreach (var player in match.Players) {
            await player.TurnEnd();
        }
    }

    public Task PreEmit(GameMatch match, int playerI)
    {
        return Task.CompletedTask;
    }
}