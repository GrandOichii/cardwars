using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public class InPlayCardData : CardData {
    public InPlayCardStatus Status { get; }
    public List<string> InPlayLandscapes { get; }

    public InPlayCardData(InPlayCardState card) : base(card.Original.Card) {
        Status = card.Original.Status;
        InPlayLandscapes = card.LandscapeTypes;
    }
}
