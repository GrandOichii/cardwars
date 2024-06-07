using CWCore.Match.Players;

namespace CWCore.Match.Actions;

public interface IAction {
    public string ActionWord();
    public Task Exec(GameMatch match, Player player, string[] args);
    public IEnumerable<string> GetAvailable(GameMatch match, Player player);
}