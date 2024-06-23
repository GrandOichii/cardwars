using CWCore.Match.States;

namespace CWCore.Match.Players.Data;

public readonly struct PlayerData {
    public string Name { get; }
    public int Idx { get; }
    public int Life { get; }
    public int ActionPoints { get; }
    public int RestrictedActionPoints { get; }
    public int DeckCount { get; }
    public int HandCount { get; }

    public List<LandscapeData> Landscapes { get; }
    
    // TODO discard pile
    // TODO landscapes

    public PlayerData(PlayerState player) {
        Name = player.Original.Name;
        Idx = player.Original.Idx;
        Life = player.Original.Life;
        ActionPoints = player.Original.ActionPoints;
        
        RestrictedActionPoints = player.Original.RestrictedActionPoints.Count;
        DeckCount = player.Original.Deck.Count;
        HandCount = player.Original.Hand.Count;

        Landscapes = player.Landscapes.Select(l => new LandscapeData(l)).ToList();
    }
}