using CWCore.Match.Players;

namespace CWCore.Match.Phases;

public interface IPhase {
    public Task Exec(GameMatch match, Player player);
}