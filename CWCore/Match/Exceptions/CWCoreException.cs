namespace CWCore.Exceptions;

[Serializable]
public class CWCoreException : Exception
{
    public CWCoreException() { }
    public CWCoreException(string message) : base(message) { }
}