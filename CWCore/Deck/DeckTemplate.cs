using CWCore.Cards;
using CWCore.Exceptions;
using CWCore.Match;
using NLua;

namespace CWCore.Decks;

// TODO add max card amount checks (default = 3)

public class DeckTemplate {
    public required Dictionary<string, int> Cards { get; set; }
    public required Dictionary<string, int> Landscapes { get; set; }

    public async Task<LinkedList<MatchCard>> ToDeck(int ownerI, ICardMaster cardMaster, Lua state, IIDGenerator generator) {
        var result = new LinkedList<MatchCard>();
        foreach (var pair in Cards)  {
            
            var cardName = pair.Key;

            var template = await cardMaster.Get(cardName);
            try {
                for (int i = 0; i < pair.Value; i++) {
                    var card = new MatchCard(template, ownerI, state, generator);
                    result.AddLast(new LinkedListNode<MatchCard>(card));
                }
            } catch (Exception e) {
                throw new CWCoreException($"failed to create card {template.Name}", e);
            }
        }
        return result;
    }
}
