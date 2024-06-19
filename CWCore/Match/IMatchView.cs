namespace CWCore.Match;

public interface IMatchView {
    /// <summary>
    /// Start the view
    /// </summary>
    public Task Start(GameMatch match);

    /// <summary>
    /// Updates the view with the new match data
    /// </summary>
    /// <param name="match">The displayed match</param>
    public Task Update(GameMatch match);

    /// <summary>
    /// Ends the view
    /// </summary>
    public Task End();
}