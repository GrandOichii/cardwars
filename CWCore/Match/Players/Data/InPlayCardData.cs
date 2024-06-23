using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public class InPlayCardData : CardData {
    public bool Flooped { get; }
    public List<string> InPlayLandscapes { get; }

    public InPlayCardData(InPlayCardState card) : base(card.Original.Card) {
        Flooped = card.Original.IsFlooped();
        InPlayLandscapes = card.LandscapeTypes;
    }
}
