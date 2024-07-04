using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public class CardData {
    public string Name { get; }
    public string Type { get; }
    public string ID { get; }
    public int Cost { get; }
    public string Text { get; }
    public string Landscape { get; protected set;  }
    public int Attack { get; }
    public int Defense { get; }

    public CardData(MatchCard card) {
        ID = card.ID;
        Name = card.Template.Name;
        Type = card.Template.Type;
        Cost = card.Template.Cost;
        Text = card.Template.Text;
        Landscape = card.Template.Landscape;
        Attack = card.Template.Attack;
        Defense = card.Template.Defense;
    }

    public CardData(CardState card) : this(card.Original) {
        Cost = card.Cost;
        Landscape = card.LandscapeType;
        // TODO dynamic text
    }
}