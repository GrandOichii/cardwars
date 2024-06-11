using CWCore.Exceptions;
using CWCore.Match;

namespace CWCore.Cards;

[System.Serializable]
public class ICardMasterException : CWCoreException
{
    public ICardMasterException() { }
    public ICardMasterException(string message) : base(message) { }
    public ICardMasterException(string message, System.Exception inner) : base(message, inner) { }
}

public interface ICardMaster {
    public Task<CardTemplate> Get(string name);
    public Task<HeroTemplate> GetHero(string name);

}