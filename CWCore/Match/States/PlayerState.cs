using CWCore.Match.Players;

namespace CWCore.Match.States;

public class PlayerState : IStateModifier {
    public Player Original { get; }
    public List<LandscapeState> Landscapes { get; set; } = new();
    public List<CardState> DiscardPile { get; set; } = new();
    public List<CardState> Hand { get; set; } = new();
    public PlayerState(Player player) {
        Original = player;
        
        // landscapes
        for (int i = 0; i < player.Landscapes.Count; i++) {
            Landscapes.Add(new(player.Landscapes[i], i));
        }

        // hand
        foreach (var card in player.Hand) {
            Hand.Add(new(card));
        }

        // discard
        foreach (var card in player.DiscardPile) {
            DiscardPile.Add(new(card));
        }
    }
    
    public void Modify(ModificationLayer layer)
    {
        foreach (var lane in Landscapes) {
            lane.Modify(layer);
        }
    }

    public List<InPlayCardState> GetCardsWithTriggeredEffects() {
        var result = new List<InPlayCardState>();
        foreach (var lane in Landscapes) {
            if (lane.Creature is not null && lane.Creature.TriggeredEffects.Count > 0) {
                result.Add(lane.Creature);
            }
            if (lane.Building is not null && lane.Building.TriggeredEffects.Count > 0) {
                result.Add(lane.Building);
            }
        }
        return result;
    }

    public Dictionary<string, int> GetLandscapeCounts() {
        var result = new Dictionary<string, int>();

        foreach (var landscape in Landscapes) {
            // TODO replace with landscape.Name
            var name = landscape.Original.Name;
            if (!result.ContainsKey(name))
                result.Add(name, 0);
            result[name]++;
        }

        return result;
    }

}