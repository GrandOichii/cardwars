namespace CWCore.Cards;

[System.Serializable]
public class ICardMasterException : System.Exception
{
    public ICardMasterException() { }
    public ICardMasterException(string message) : base(message) { }
    public ICardMasterException(string message, System.Exception inner) : base(message, inner) { }
    protected ICardMasterException(
        System.Runtime.Serialization.SerializationInfo info,
        System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
}

public interface ICardMaster {
    public Task<CardTemplate> Get(string name);
}