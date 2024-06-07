using CWCore.Cards;
using CWCore.Match;
using NLua;

namespace CWCore.Decks;

public class DeckTemplate {
    public required Dictionary<string, int> Cards { get; set; }
    // TODO utilize
    public required Dictionary<string, int> Landscapes { get; set; }

    public async Task<LinkedList<MatchCard>> ToDeck(ICardMaster cardMaster, Lua state, IIDGenerator generator) {
        var result = new LinkedList<MatchCard>();
        foreach (var pair in Cards)  {
            var cardName = pair.Key;
            var card = await cardMaster.Get(cardName);
            for (int i = 0; i < pair.Value; i++)
                result.AddLast(new LinkedListNode<MatchCard>(new(card, state, generator)));
        }
        return result;
    }
}
