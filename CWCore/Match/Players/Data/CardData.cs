using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public class CardData {
    public string Name { get; }
    public string Type { get; }
    public string ID { get; }
    public int Cost { get; }
    public string Text { get; }

    public CardData(MatchCard card) {
        ID = card.ID;
        Name = card.Template.Name;
        Type = card.Template.Type;
        Cost = card.Template.Cost;
        Text = card.Template.Text;
    }

    public CardData(CardState card) : this(card.Original) {
        Cost = card.Cost;
        // TODO dynamic text
    }
}