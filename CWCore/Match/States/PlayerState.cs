using System.Drawing;
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
        
        Landscapes = player.Landscapes.Select(
            (landscape, i) => new LandscapeState(this, landscape, i)
        ).ToList();

        Hand = player.Hand.Select(
            c => new CardState(this, c)
        ).ToList();

        DiscardPile = player.DiscardPile.Select(
            c => new CardState(this, c)
        ).ToList();

        CardsPlayedThisTurn = player.CardsPlayedThisTurn.Select(
            c => new CardState(this, c)
        ).ToList();
    }

    public void PreModify() {
        foreach (var landscape in Landscapes) {
            if (landscape.IsFrozen()) {
                Hand.ForEach(c => c.LanePlayRestrictions[landscape.Original.Idx].Clear());
                Hand.ForEach(c => c.LanePlayRestrictions[landscape.Original.Idx].Add("IsFrozen"));
            }
        }
    }
    
    public void Modify(ModificationLayer layer)
    {
        Original.Hero?.Modify(layer);
        Hand.ForEach(card => card.Modify("hand", layer));

        Landscapes.ForEach(landscape => landscape.Modify(layer));

        foreach (var effect in Original.UntilNextTurnEffects) {
            try {
                effect.Call((int)layer);
            } catch (Exception e) {
                throw new GameMatchException($"failed to execute \"until next turn\" effect of player {Original.LogFriendlyName}", e);
            }
        }
    }

    public List<InPlayCardState> GetCardsWithTriggeredAbilities() {
        return GetInPlayCards()
                .Where(c => c.TriggeredAbilities.Count > 0)
                .ToList();
    }

    public Dictionary<string, int> GetLandscapeCounts() {
        var result = new Dictionary<string, int>();

        foreach (var landscape in Landscapes) {
            if (landscape.Original.FaceDown) continue;
            
            var name = landscape.GetName();
            if (!result.ContainsKey(name))
                result.Add(name, 0);
            result[name]++;
        }

        return result;
    }

    public List<int> LandscapesAvailableForCreature(CardState creature) {
        var result = new List<int>();
        for (int i = 0; i < Landscapes.Count; i++) {
            var landscape = Landscapes[i];
            if (creature.LanePlayRestrictions[i].Count > 0) continue;
            if (!landscape.CanPlayCreature(creature)) continue;

            var existing = landscape.Creature;
            if (existing is not null) {
                if (existing.Original.Exhausted) continue;
            }

            if (!CanPayFor(creature, i)) continue;

            result.Add(i);
        }
        return result;
    }

    public List<int> LandscapesAvailableForBuilding(CardState building) {
        var result = new List<int>();
        for (int i = 0; i < Landscapes.Count; i++) {
            var landscape = Landscapes[i];
            if (building.LanePlayRestrictions[i].Count > 0) continue;
            if (!landscape.CanPlayBuilding(building)) continue;

            // TODO? players can replace flooped buildings, don't know how the rules interact with Burly Lumberjack
            result.Add(i);
        }
        return result;
    }

    public async Task<int> PickLaneForCreature(CardState creature) {
        var options = LandscapesAvailableForCreature(creature);
        var result = await Original.Controller.PickLaneForCreature(Original.Match, Original.Idx, options);
        return result;
    }

    public async Task<int> PickLaneForBuilding(CardState building) {
        var options = LandscapesAvailableForBuilding(building);
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

    public async Task PlayCreature(CardState card, bool forFree = false) {
        var laneI = await PickLaneForCreature(card);

        if (laneI >= Original.Match.Config.LaneCount || laneI < 0) {
            var errMsg = $"Player {Original.LogFriendlyName} tried to play card {card.Original.LogFriendlyName} in lane {laneI}";
            throw new GameMatchException(errMsg);
        }
        if (!forFree && !card.PayCosts(this, laneI)) {
            throw new GameMatchException($"Player {Original.LogFriendlyName} tried to play card {card.Original.LogFriendlyName}, but didn't pay it's costs");
        }

        await Original.PlaceCreatureInLane(card.Original, laneI);
    }

    public async Task PlayBuilding(CardState card, bool forFree = false) {
        var laneI = await PickLaneForBuilding(card);

        if (laneI >= Original.Match.Config.LaneCount || laneI < 0) {
            var errMsg = $"Player {Original.LogFriendlyName} tried to play card {card.Original.LogFriendlyName} in lane {laneI}";
            throw new GameMatchException(errMsg);
        }
        if (!forFree && !card.PayCosts(this, laneI)) {
            throw new GameMatchException($"Player {Original.LogFriendlyName} tried to play card {card.Original.LogFriendlyName}, but didn't pay it's costs");
        }

        await Original.PlaceBuildingInLane(card.Original, laneI);

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

        match.CardsPlayed.Add($"({player.Idx}) {card.Original.LogFriendlyName}");

        if (card.Original.IsSpell) {
            // TODO move to a separate method
            
            if (!forFree && !card.PayCosts(this)) {
                throw new GameMatchException($"Player {player.LogFriendlyName} tried to play card {card.Original.LogFriendlyName}, but didn't pay it's costs");
            }

            await player.ExecuteSpellEffect(card.Original);

            match.GetPlayer(card.Original.OwnerI).AddToDiscard(card.Original);

            return;
        }

        if (card.Original.IsCreature) {
            await PlayCreature(card);
            return;
        }

        if (card.Original.IsBuilding) {
            await PlayBuilding(card);
            return;
        }

        throw new GameMatchException($"Unrecognized card type: {card.Original.Template.Type}");
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
            result.AddRange(landscape.Buildings);
        }

        return result;
    }

    public bool CanPayFor(CardState card) {
        // in-play card
        if (!card.Original.IsSpell) {
            return Landscapes.Any(
                landscape => CanPayFor(card, landscape.Original.Idx)
            );
        }

        // spell
        int amount = 0;
        foreach (var ap in Original.RestrictedActionPoints) {
            if (!ap.CanBeSpentOn(this, card)) continue;

            ++amount;
        }
        return Original.ActionPoints + amount >= card.Cost;
    }

    public bool CanPayFor(CardState card, int laneI) {
        int amount = 0;
        foreach (var ap in Original.RestrictedActionPoints) {
            if (!ap.CanBeSpentOn(this, card, laneI)) continue;

            ++amount;
        }
        return Original.ActionPoints + amount >= card.Cost;
    }


    public void PayActionPoints(int amount) {
        Original.ActionPoints -= amount;
        // TODO add back
        // if (ActionPoints < 0) {
        //     Match.LogError($"Player payed {amount} ap, which resulted in their ap being equal to {ActionPoints}");
        // }
        // TODO? add update
    }

    public void PayActionPoints(CardState card, int? laneI) {
        var amount = card.Cost;
        while (amount > 0) {
            var ap = Original.RestrictedActionPoints.FirstOrDefault(ap => ap.CanBeSpentOn(this, card, laneI));
            if (ap is null) break;
            amount--;
            Original.RestrictedActionPoints.Remove(ap);
        }
        PayActionPoints(amount);
    }

    public void PayToPlay(CardState card, int? laneI) {
        PayActionPoints(card, laneI);
    }
}