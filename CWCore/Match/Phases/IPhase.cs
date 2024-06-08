using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public interface IPhase {
    public Task Exec(GameMatch match, int playerI);
}