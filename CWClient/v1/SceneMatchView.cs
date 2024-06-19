namespace CWClient.v1;

public class SceneMatchView : IMatchView
{
    private readonly MatchScene _match;
    public SceneMatchView(MatchScene match)
    {
        _match = match;
    }
    public Task End()
    {
        return Task.CompletedTask;
    }

    public Task Start(GameMatch match)
    {
        return Task.CompletedTask;
    }

    public Task Update(GameMatch match)
    {
        _match.Load(match);
        return Task.CompletedTask;
    }
}
