using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public interface IPhase {
    public string GetName();
    public Task PreEmit(GameMatch match, int playerI);
    public Task PostEmit(GameMatch match, int playerI);
}