using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class BattlePhase : IPhase
{
    public Task Exec(GameMatch match, Player player, PlayerState playerState)
    {
        match.LogInfo($"Player {player.LogFriendlyName} proceeds to battle");
        
        while (CanAttack(playerState)) {
            
        }
        // TODO

        return Task.CompletedTask;
    }

    public bool CanAttack(PlayerState player) {
        foreach (var lane in player.Landscapes) {
            if (lane.Creature is null) continue;

            if (lane.Creature.CanAttack) return true;
        }

        return false;
    }
}
