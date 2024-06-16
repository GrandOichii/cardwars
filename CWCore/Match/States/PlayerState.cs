using CWCore.Exceptions;
using CWCore.Match.Players;

namespace CWCore.Match.States;

public class PlayerState : IStateModifier {
    public Player Original { get; }
    public List<LandscapeState> Landscapes { get; } = new();
    public List<CardState> DiscardPile { get; } = new();
    public List<CardState> Hand { get; } = new();
    public List<CardState> CardsPlayedThisTurn { get; } = new();
    
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

        // cards played this turn
        foreach (var card in player.CardsPlayedThisTurn) {
            CardsPlayedThisTurn.Add(new(card));
        }
    }
    
    public void Modify(ModificationLayer layer)
    {
        Original.Hero?.Modify(layer);

        foreach (var card in Hand) {
            card.Modify(layer);
        }
        
        foreach (var lane in Landscapes) {
            lane.Modify(layer);
        }

        foreach (var effect in Original.UntilNextTurnEffects) {
            try {
                effect.Call((int)layer);
            } catch (Exception e) {
                throw new CWCoreException($"failed to execute \"until next turn\" effect of player {Original.LogFriendlyName}", e);
            }
        }
    }

    public List<InPlayCardState> GetCardsWithTriggeredAbilities() {
        var result = new List<InPlayCardState>();
        foreach (var lane in Landscapes) {
            if (lane.Creature is not null && lane.Creature.TriggeredAbilities.Count > 0) {
                result.Add(lane.Creature);
            }
            if (lane.Building is not null && lane.Building.TriggeredAbilities.Count > 0) {
                result.Add(lane.Building);
            }
        }
        return result;
    }

    public Dictionary<string, int> GetLandscapeCounts() {
        var result = new Dictionary<string, int>();

        foreach (var landscape in Landscapes) {
            // TODO? replace with landscape.Name
            var name = landscape.Original.Name;
            if (!result.ContainsKey(name))
                result.Add(name, 0);
            result[name]++;
        }

        return result;
    }

    public List<int> LandscapesAvailableForCreatures() {
        var result = new List<int>();
        for (int i = 0; i < Landscapes.Count; i++) {
            var landscape = Landscapes[i];
            if (!landscape.CanPlayCreature) continue;
            var creature = landscape.Creature;
            if (creature is not null) {
                if (creature.Original.Exhausted) continue;
            }
            result.Add(i);
        }
        return result;
    }

    public List<int> LandscapesAvailableForBuildings() {
        var result = new List<int>();
        for (int i = 0; i < Landscapes.Count; i++) {
            var landscape = Landscapes[i];
            if (!landscape.CanPlayBuilding) continue;
            var building = landscape.Building;
            if (building is not null) {
                if (building.Original.IsFlooped()) continue;
            }
            result.Add(i);
        }
        return result;
    }

    public async Task<int> PickLaneForCreature() {
        var options = LandscapesAvailableForCreatures();
        var result = await Original.Controller.PickLaneForCreature(Original.Match, Original.Idx, options);
        return result;
    }

    public async Task<int> PickLaneForBuilding() {
        // TODO not specified in the rules, check

        var options = LandscapesAvailableForBuildings();
        var result = await Original.Controller.PickLaneForBuilding(Original.Match, Original.Idx, options);
        return result;
    }

    public async Task PlayCard(string cardId, bool forFree) {
        var card = Hand.FirstOrDefault(card => card.Original.ID == cardId);
        if (card is null) {
            var errMsg = $"Player {Original.LogFriendlyName} tried to play a card with id {cardId}, which they don't have in their hand";
            Original.Match.ActionError(errMsg);
            return;
        }
        await PlayCard(card, forFree);
    }

    public async Task PlayCard(CardState card, bool forFree) {
        var player = Original;
        var match = player.Match;
        var owned = player.Idx == card.Original.OwnerI;
        if (!card.CanPlay(this, forFree)) {
            var errMsg = $"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName}, which they cant";
            match.ActionError(errMsg);
            return;
        }

        if (owned)
            player.RemoveFromHand(card.Original);
        await player.Match.ReloadState();

        if (!forFree) {

            var payed = card.PayCosts(this);
            if (!payed) {
                // TODO? is this required? could break
                if (owned)
                    player.Hand.Add(card.Original);
                match.ActionError($"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName}, but didn't pay it's costs");
                return;
            }
        }

        match.CardsPlayed.Add($"({player.Idx}) {card.Original.LogFriendlyName}");

        if (card.Original.IsSpell) {
            await player.PlaySpellEffect(card.Original);

            match.GetPlayer(card.Original.OwnerI).AddToDiscard(card.Original);

            return;
        }

        if (card.Original.IsCreature) {
            var laneI = await PickLaneForCreature();

            if (laneI >= match.Config.LaneCount || laneI < 0) {
                var errMsg = $"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName} in lane {laneI}";
                throw new CWCoreException(errMsg);
            }

            await player.PlaceCreatureInLane(card.Original, laneI);

            return;
        }

        if (card.Original.IsBuilding) {
            var laneI = await PickLaneForBuilding();

            if (laneI >= match.Config.LaneCount || laneI < 0) {
                var errMsg = $"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName} in lane {laneI}";
                throw new CWCoreException(errMsg);
            }

            await player.PlaceBuildingInLane(card.Original, laneI);

            return;
        }

        throw new CWCoreException($"Unrecognized card type: {card.Original.Template.Type}");

    }
    
    public InPlayCardState GetInPlayCard(string id) {
        return GetInPlayCardOrDefault(id) ?? throw new GameMatchException($"player {Original.LogFriendlyName} doesn't have an in-play card with id {id}");
    }

    public InPlayCardState? GetInPlayCardOrDefault(string id) {
        return GetInPlayCards().FirstOrDefault(c => c.Original.Card.ID == id);
    }

    public List<InPlayCardState> GetInPlayCards() {
        var result = new List<InPlayCardState>();

        foreach (var landscape in Landscapes) {
            var creature = landscape.Creature;
            if (creature is not null) result.Add(creature);
            var building = landscape.Creature;
            if (building is not null) result.Add(building);
        }

        return result;
    }


}