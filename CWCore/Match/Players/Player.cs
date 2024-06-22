using CWCore.Decks;
using CWCore.Exceptions;
using CWCore.Match.States;
using CWCore.Utility;
using NLua;

namespace CWCore.Match.Players;

public class Player {
    public GameMatch Match { get; }
    public string Name { get; }
    public IPlayerController Controller { get; }
    public int Idx { get; }
    private readonly Dictionary<string, int> _landscapeIndex;

    public int Life { get; set; }
    public int ActionPoints { get; set; }
    public List<RestrictedActionPoint> RestrictedActionPoints { get; }
    public List<Landscape> Landscapes { get; set; } = new();

    public LinkedList<MatchCard> Deck { get; private set; }
    public Hero? Hero { get; set; }

    public List<MatchCard> Hand { get; }
    public List<MatchCard> DiscardPile { get; set; }

    public List<MatchCard> CardsPlayedThisTurn { get; }
    public List<MatchCard> EnteredDiscardThisTurn { get; }
    public List<LuaFunction> UntilNextTurnEffects { get; }
    public List<LuaFunction> AtTheStartOfNextTurnEffects { get; }

    public Player(GameMatch match, string name, int idx, Dictionary<string, int> landscapeIndex, LinkedList<MatchCard> deck, Hero? hero, IPlayerController controller) {
        Match = match;
        Name = name;
        Idx = idx;
        Controller = controller;
        Deck = deck;
        _landscapeIndex = landscapeIndex;
        Hero = hero;

        Life = Match.Config.StartingLifeTotal;
        RestrictedActionPoints = new();
        Hand = new();
        DiscardPile = new();
        CardsPlayedThisTurn = new();
        EnteredDiscardThisTurn = new();
        UntilNextTurnEffects = new();
        AtTheStartOfNextTurnEffects = new();
    }

    public string LogFriendlyName => $"{Name} [{Idx}]";

    public async Task ResetActionPoints() {
        ActionPoints = Match.Config.ActionPointsPerTurn;
        RestrictedActionPoints.Clear();
        // TODO? add update
    }

    public async Task ReadyInPlayCards() {
        foreach (var lane in Landscapes) {
            if (lane.Creature is not null) {
                await Match.ReadyCard(lane.Creature);
            }
            foreach (var b in lane.Buildings)
                await Match.ReadyCard(b);
        }
    }

    public async Task<int> Draw(int amount) {
        int drawn = 0;
        for (int i = 0; i < amount; i++) {
            if (Deck.Count == 0) {
                Match.LogInfo($"Player {LogFriendlyName} tried to draw out of an empty deck");
                break;
            }

            var card = Deck.Last!.Value;
            Deck.RemoveLast();
            Hand.Add(card);
            // TODO? add to update

            drawn++;
        }

        Match.LogInfo($"Player {LogFriendlyName} drew {drawn} cards");
        await Match.Emit("card_draw", new() {
            { "playerI", Idx },
            { "amount", drawn },
            { "fromBottom", false },
        });

        return drawn;
    }

    public async Task<int> DrawFromBottom(int amount) {
        int drawn = 0;
        for (int i = 0; i < amount; i++) {
            if (Deck.Count == 0) {
                Match.LogInfo($"Player {LogFriendlyName} tried to draw out of an empty deck");
                break;
            }

            var card = Deck.First!.Value;
            Deck.RemoveFirst();
            Hand.Add(card);
            // TODO? add to update

            drawn++;
        }

        Match.LogInfo($"Player {LogFriendlyName} drew {drawn} cards from the bottom of their deck");
        await Match.Emit("card_draw", new() {
            { "playerI", Idx },
            { "amount", drawn },
            { "fromBottom", false },
        });


        return drawn;
    }

    public void RemoveFromHand(MatchCard card) {
        // TODO? add to update

        var removed = Hand.Remove(card);
        if (!removed) throw new GameMatchException($"tried to remove card with id {card.ID} from hand of player {LogFriendlyName}, which they don't have in hand");
    }

    public void AddToDiscard(MatchCard card) {
        EnteredDiscardThisTurn.Add(card);
        DiscardPile.Add(card);
    }

    public Task<int> ProcessDamage(int amount) {
        var result = Life;
        Life -= amount;
        if (Life < 0) Life = 0;

        result -= Life;

        Match.LogInfo($"Player {LogFriendlyName} was dealt {result} damage");

        return Task.FromResult(result);
    }

    public async Task Setup() {
        await PlaceLandscapes();

        Deck = Common.Shuffled(Deck, Match.Rng);
        await Draw(Match.Config.StartHandSize);

        // Mill(Deck.Count / 2);

        await Controller.Setup(Match, Idx);
    }

    private async Task PlaceLandscapes() {
        var result = await Controller.PromptLandscapePlacement(Match, Idx, _landscapeIndex);
        
        // TODO validate landscape choice
        // TODO validate landscape names
        
        for (int i = 0; i < result.Count; i++) {
            var landscape = new Landscape(result[i], Idx, i);
            Landscapes.Add(landscape);
        }
    }

    public Task ExecuteSpellEffect(MatchCard card) {
        CardsPlayedThisTurn.Add(card);

        try {
            card.ExecFunction(MatchCard.SPELL_EFFECT_FNAME, card.Data, card.ID, Idx);

        } catch (Exception e) {
            throw new GameMatchException($"error in spell effect of card {card.LogFriendlyName}", e);
        }
        return Task.CompletedTask;
    }

    public async Task<int> PickAttackLane(List<int> options) {
        var result = await Controller.PickAttackLane(Match, Idx, options);
        // TODO validate
        return result;
    }

    public async Task PlaceCreatureInLane(MatchCard card, int laneI) {
        // * for updating replaced creatures
        await Match.ReloadState();
        if (!Match.Active) return;

        var landscape = Match.LastState.Players[Idx].Landscapes[laneI];
        var creature = new Creature(card, Idx);

        var replaced = false;
        if (landscape.Creature is not null) {
            await LeavePlay(landscape, landscape.Creature);
            replaced = true;
        }

        landscape.Original.Creature = creature;
        landscape.Original.CreaturesEnteredThisTurn.Add(card);

        CardsPlayedThisTurn.Add(card);

        await Match.ReloadState();
        if (!Match.Active) return;

        var state = Match.GetInPlayCreature(card.ID);
        if (state.ProcessEnter)
            creature.Card.ExecFunction(InPlayCard.ON_ENTER_PLAY_FNAME, creature.Card.Data, state, Idx, laneI, replaced);

        await Match.Emit("creature_enter", new() {
            {"id", creature.Card.ID},
            {"Original", creature},
            {"controllerI", Idx},
            {"laneI", laneI},
            {"replaced", replaced}
        });
    }

    public async Task PlaceBuildingInLane(MatchCard card, int laneI) {
        var landscape = Match.LastState.Players[Idx].Landscapes[laneI];

        var building = new InPlayCard(card, Idx);

        var replaced = false;
        if (landscape.BuildingPlayLimit > 0 && landscape.Buildings.Count >= landscape.BuildingPlayLimit) {
            // TODO this removes the first building placed, doesn't allow the player to choose
            var first = landscape.Buildings.First();
            landscape.Original.Buildings.Remove(first.Original);
            await LeavePlay(landscape, first);
            replaced = true;
        }

        landscape.Original.Buildings.Add(building);

        CardsPlayedThisTurn.Add(card);
        await Match.ReloadState();
        if (!Match.Active) return;

        var state = Match.GetInPlayBuilding(card.ID);
        if (state.ProcessEnter)
            state.Original.Card.ExecFunction(InPlayCard.ON_ENTER_PLAY_FNAME, building.Card.Data, state, Idx, laneI, replaced);

        await Match.Emit("building_enter", new() {
            {"id", building.Card.ID},
            {"Original", building},
            {"controllerI", Idx},
            {"laneI", laneI},
            {"replaced", replaced}
        });
    }

    public async Task<int> PickLane(List<int> options, string hint) {
        var result = await Controller.PickLane(Match, Idx, options, hint);
        if (
            !options.Contains(result) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking lane - {result} (player: {LogFriendlyName})");
        return result;
    }

    public async Task<int[]> PickLandscape(List<int> options, List<int> opponentOptions, string hint) {
        var result = await Controller.PickLandscape(Match, Idx, options, opponentOptions, hint);

        if (
            !options.Contains(result[1]) && 
            !opponentOptions.Contains(result[1]) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking landscape - {result} (player: {LogFriendlyName})");

        return result;
    }

    public async Task<int[]> PickCardInDiscard(List<int> options, List<int> opponentOptions, string hint) {
        var result = await Controller.PickCardInDiscard(Match, Idx, options, opponentOptions, hint);

        if (
            !options.Contains(result[1]) && 
            !opponentOptions.Contains(result[1]) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking card in discard - {result} (player: {LogFriendlyName})");

        return result;
    }

    public async Task<string> PickCreature(List<string> options, string hint) {
        var result = await Controller.PickCreature(Match, Idx, options, hint);
        if (
            !options.Contains(result) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking creature - {result} (player: {LogFriendlyName})");

        return result;
    }

    public async Task<string> PickBuilding(List<string> options, string hint) {
        var result = await Controller.PickBuilding(Match, Idx, options, hint);
        if (
            !options.Contains(result) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking building - {result} (player: {LogFriendlyName})");
        return result;
    }

    public async Task<string> Pick(List<string> options, string hint) {
        var result = await Controller.PickOption(Match, Idx, options, hint);
        if (
            !options.Contains(result) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking option - {result} (player: {LogFriendlyName})");
        return result;
    }

    public async Task<int> PickCardInHand(List<int> options, string hint) {
        var result = await Controller.PickCardInHand(Match, Idx, options, hint);
        if (
            !options.Contains(result) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking card in hand - {result} (player: {LogFriendlyName})");
        return result;
    }

    public async Task<int> PickCard(List<string> options, string hint) {
        var result = await Controller.PickCard(Match, Idx, options, hint);
        if (
            (result < 0 || 
            result >= options.Count) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking lane - {result} (player: {LogFriendlyName})");
        return result;
    }

    public async Task<int> PickPlayer(List<int> options, string hint) {
        var result = await Controller.PickPlayer(Match, Idx, options, hint);
        if (
            !options.Contains(result) &&
            Match.Config.StrictMode
        ) throw new GameMatchException($"invalid choice for picking player - {result} (player: {LogFriendlyName})");
        return result;
    }

    public async Task DiscardCardFromHand(int cardI) {
        var card = Hand[cardI];
        RemoveFromHand(card);
        AddToDiscard(card);

        Match.LogInfo($"Player {LogFriendlyName} discarded card {card.ID} (idx: {cardI})");

        await Match.Emit("discard_from_hand", new() {
            {"Card", card},
        });    
    }

    public async Task ReturnCreatureToHand(int laneI) {
        var lane = Landscapes[laneI];
        var creature = lane.Creature 
            ?? throw new GameMatchException($"tried to return creature from lane {laneI} to hand, where there is no creature")
        ;

        lane.Creature = null;
        Hand.Add(creature.Card);
        
        // TODO add triggers
    }

    public async Task HealHitPoints(int amount) {
        Life += amount;
        if (Life > Match.Config.StartingLifeTotal)
            Life = Match.Config.StartingLifeTotal;

        // TODO add trigger
    }

    public async Task LoseHitPoints(int amount) {
        Life -= amount;
        if (Life < 0) {
            Life = 0;
            return;
        }

        // TODO add trigger
    }

    public async Task LeavePlay(LandscapeState landscape, InPlayCardState card) {
        Match.GetPlayer(card.Original.Card.OwnerI).AddToDiscard(card.Original.Card);

        card.OnLeavePlay(landscape);
    }

    public void PlaceFromDiscardOnTopOfDeck(int cardI) {
        var card = DiscardPile[cardI];

        DiscardPile.Remove(card);
        Deck.AddLast(card);
        
        // TODO add update
    }

    public List<MatchCard> Mill(int amount) {
        var result = new List<MatchCard>();

        while (amount > 0) {
            if (Deck.Count == 0) break;
            var card = Deck.Last!.Value;
            Deck.RemoveLast();
            AddToDiscard(card);
            result.Add(card);
            amount--;
        }

        return result;
    }

    public async Task TurnStart() {
        UntilNextTurnEffects.Clear();
        
        await ResetActionPoints();

        foreach (var landscape in Landscapes) {
            var creature = landscape.Creature;
            if (creature is not null) {
                creature.MovementCount = 0;
                creature.EnteredThisTurn = false;
            } 
            foreach (var building in landscape.Buildings) {
                building.EnteredThisTurn = false;
            }
        }
        
        await ReadyInPlayCards();

        // TODO catch exceptions
        for (int i = 0; i < AtTheStartOfNextTurnEffects.Count; i++) {
            var effect = AtTheStartOfNextTurnEffects[i];
            try {
                effect.Call();
            } catch (Exception e) {
                throw new GameMatchException($"failed to execute \"at the start of next turn effect\" at {i}", e);
            }
        }
        AtTheStartOfNextTurnEffects.Clear();

        await Draw(Match.Config.FreeDraw);
    }

    public async Task TurnEnd() {
        CardsPlayedThisTurn.Clear();
        EnteredDiscardThisTurn.Clear();

        foreach (var landscape in Landscapes) {
            landscape.CreaturesEnteredThisTurn.Clear();

            if (landscape.Creature is not null)
                landscape.Creature.Attacking = false;
            
            // clear ability activations
            var cards = new List<InPlayCard?>() { landscape.Creature };
            cards.AddRange(landscape.Buildings);
            foreach (var card in cards) {
                if (card is null) continue;
                foreach (var a in card.ActivatedAbilities)
                    a.ActivatedThisTurn = 0;
            }
        }
    }

    public void RemoveFromDiscard(int cardI) {
        DiscardPile.RemoveAt(cardI);
    }

    public async Task UpdateController() {
        await Controller.Update(Match, Idx);
    }

    public List<MatchCard> DeckAsList() => Deck.ToList();
}

