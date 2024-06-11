using CWCore.Decks;
using CWCore.Exceptions;
using CWCore.Match.States;
using CWCore.Utility;

namespace CWCore.Match.Players;

public class Player {
    public string Name { get; }
    public IPlayerController Controller { get; }
    public int Idx { get; }
    private readonly Dictionary<string, int> _landscapeIndex;

    public int Life { get; set; }
    public int ActionPoints { get; set; }
    public List<Landscape> Landscapes { get; set; } = new();

    public GameMatch Match { get; }
    public LinkedList<MatchCard> Deck { get; private set; }

    public List<MatchCard> Hand { get; }
    public List<MatchCard> DiscardPile { get; set; }

    public List<MatchCard> CardsPlayedThisTurn { get; }
    // TODO utilize
    public List<MatchCard> EnteredDiscardThisTurn { get; }

    public Player(GameMatch match, string name, int idx, Dictionary<string, int> landscapeIndex, LinkedList<MatchCard> deck, IPlayerController controller) {
        Match = match;
        Name = name;
        Idx = idx;
        Controller = controller;
        Deck = deck;
        _landscapeIndex = landscapeIndex;

        Hand = new();
        DiscardPile = new();
        CardsPlayedThisTurn = new();
        EnteredDiscardThisTurn = new();
    }

    public string LogFriendlyName => $"{Name} [{Idx}]";

    public async Task ResetActionPoints() {
        ActionPoints = Match.Config.ActionPointsPerTurn;
        // TODO? add update
    }

    public async Task ReadyInPlayCards() {
        foreach (var lane in Landscapes) {
            if (lane.Creature is not null) {
                await Match.ReadyCard(lane.Creature);
            }
            if (lane.Building is not null) {
                await Match.ReadyCard(lane.Building);
            }
        }
    }

    public int Draw(int amount) {
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

        return drawn;
    }

    public void PayActionPoints(int amount) {
        ActionPoints -= amount;        
        if (ActionPoints < 0) {
            Match.LogError($"Player payed {amount} ap, which resulted in their ap being equal to {ActionPoints}");
        }
        // TODO? add update
    }

    public void PayToPlay(CardState card) {
        // TODO pay additional costs
        
        PayActionPoints(card.Cost);
    }

    public void RemoveFromHand(MatchCard card) {
        // TODO? add to update

        var removed = Hand.Remove(card);
        if (!removed) throw new CWCoreException($"tried to remove card with id {card.ID} from hand of player {LogFriendlyName}, which they don't have in hand");
    }

    public void AddToDiscard(MatchCard card) {
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
        Life = Match.Config.StartingLifeTotal;
        await PlaceLandscapes();

        Deck = Common.Shuffled(Deck, Match.Rng);
        Draw(Match.Config.StartHandSize);
    }

    private async Task PlaceLandscapes() {
        var result = await Controller.PromptLandscapePlacement(Idx, _landscapeIndex);
        
        // TODO validate landscape choice
        
        for (int i = 0; i < result.Count; i++) {
            var landscape = new Landscape(result[i], Idx, i);
            Landscapes.Add(landscape);
        }
    }

    public Task PlaySpellEffect(MatchCard card) {
        CardsPlayedThisTurn.Add(card);

        card.ExecFunction(MatchCard.SPELL_EFFECT_FNAME, card.Data, Idx);
        return Task.CompletedTask;
    }

    public async Task<int> PickAttackLane(List<int> options) {
        var result = await Controller.PickAttackLane(Match, Idx, options);
        return result;
    }

    public async Task PlaceCreatureInLane(MatchCard card, int laneI) {
        var lane = Landscapes[laneI];
        var creature = new Creature(card, Idx);

        var replaced = false;
        if (lane.Creature is not null) {
            await LeavePlay(lane, lane.Creature);
            replaced = true;
        }

        lane.Creature = creature;

        CardsPlayedThisTurn.Add(card);

        await Match.ReloadState();
        if (!Match.Active) return;

        creature.Card.ExecFunction(InPlayCard.ON_ENTER_PLAY_FNAME, creature.Card.Data, Idx, laneI, replaced);

        await Match.Emit("creature_enter", new() {
            {"ownerI", Idx},
            {"laneI", laneI},
            {"replaced", replaced}
        });
    }

    public async Task PlaceBuildingInLane(MatchCard card, int laneI) {
        var lane = Landscapes[laneI];
        var building = new InPlayCard(card, Idx);

        var replaced = false;
        if (lane.Building is not null) {
            await LeavePlay(lane, lane.Building);
            replaced = true;
        }

        lane.Building = building;

        CardsPlayedThisTurn.Add(card);
        await Match.ReloadState();
        building.Card.ExecFunction(InPlayCard.ON_ENTER_PLAY_FNAME, building.Card.Data, Idx, laneI, replaced);
        // TODO add triggers
    }

    public async Task<int> PickLane(List<int> options, string hint) {
        var result = await Controller.PickLane(Match, Idx, options, hint);
        // TODO validate
        return result;
    }

    public async Task<int[]> PickLandscape(List<int> options, List<int> opponentOptions, string hint) {
        var result = await Controller.PickLandscape(Match, Idx, options, opponentOptions, hint);
        // TODO validate
        return result;
    }

    public async Task<string> PickCreature(List<string> options, string hint) {
        var result = await Controller.PickCreature(Match, Idx, options, hint);
        // TODO validate

        return result;
    }

    public async Task<string> PickBuilding(List<string> options, string hint) {
        var result = await Controller.PickBuilding(Match, Idx, options, hint);
        // TODO validate
        return result;
    }

    public async Task<string> Pick(List<string> options, string hint) {
        var result = await Controller.PickOption(Match, Idx, options, hint);
        // TODO validate
        return result;
    }

    public async Task<int> PickCardInHand(List<int> options, string hint) {
        var result = await Controller.PickCardInHand(Match, Idx, options, hint);
        // TODO validate
        return result;
    }

    public async Task DiscardCardFromHand(int cardI) {
        var card = Hand[cardI];
        RemoveFromHand(card);
        AddToDiscard(card);

        Match.LogInfo($"Player {LogFriendlyName} discarded card {card.ID} (idx: {cardI})");
        // TODO add to "cards discarded this turn" counter
        // TODO add trigger
    }

    public async Task ReturnCreatureToHand(int laneI) {
        var lane = Landscapes[laneI];
        var creature = lane.Creature 
            ?? throw new CWCoreException($"tried to return creature from lane {laneI} to hand, where there is no creature")
        ;

        lane.Creature = null;
        Hand.Add(creature.Card);
        
        // TODO add triggers
    }

    public async Task ReturnBuildingToHand(int laneI) {
        // TODO
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
            // TODO tell match
        }

        // TODO add trigger
    }

    public async Task LeavePlay(Landscape landscape, InPlayCard card) {
        AddToDiscard(card.Card);

        card.Card.ExecFunction(
            InPlayCard.ON_LEAVE_PLAY_FNAME, 
            card.Card.Data, 
            Idx, 
            landscape.Idx
        );
    }
}
