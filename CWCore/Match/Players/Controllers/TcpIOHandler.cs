
using System.Net.Sockets;

namespace CWCore.Match.Players.Controllers;

public class TcpIOHandler : IIOHandler
{
    private readonly TcpClient _client;

    public TcpIOHandler(TcpClient client) {
        _client = client;
    }

    public Task<string> Read()
    {
        return Task.FromResult(
            NetUtility.Read(_client.GetStream())
        );
    }

    public Task Write(string msg)
    {
        NetUtility.Write(_client.GetStream(), msg);
        return Task.CompletedTask;
    }
}
