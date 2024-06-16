namespace CWCore.Exceptions;

[System.Serializable]
public class GameMatchException : CWCoreException
{
    public GameMatchException() : base() { }
    public GameMatchException(string message) : base(message) { }
    public GameMatchException(string message, Exception inner) : base(message, inner) { }
}