using NLua;
using CWCore.Utility;

namespace CWCore.Cards;

public class CardTemplate :  HeroTemplate {
    public required string Type { get; set; }
    public required string Landscape { get; set; }
    public required int Cost { get; set; }
    public int Attack { get; set; } = -1;
    public int Defense { get; set; } = -1;

}