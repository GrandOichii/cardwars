using CWCore.Match.Players;

namespace CWCore.Match.Phases;

public class BattlePhase : IPhase
{
    public Task Exec(GameMatch match, Player player)
    {
        match.LogInfo($"Player {player.LogFriendlyName} proceeds to battle");
        
        // TODO

        return Task.CompletedTask;
    }
}
