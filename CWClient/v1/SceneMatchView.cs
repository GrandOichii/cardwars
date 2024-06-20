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
        _match.Player1Node.LoadConfig(match.Config);
        _match.Player2Node.LoadConfig(match.Config);
        return Task.CompletedTask;
    }

    public Task Update(GameMatch match)
    {
        _match.Load(match);
        return Task.CompletedTask;
    }
}
