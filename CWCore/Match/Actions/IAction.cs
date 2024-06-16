using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Actions;

public interface IAction {
    public Task Exec(GameMatch match, int playerI, string[] args);
    public string ActionWord();
    public IEnumerable<string> GetAvailable(GameMatch match, int playerI);
}