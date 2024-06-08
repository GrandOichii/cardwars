using CWCore.Decks;
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

    private readonly GameMatch _match;
    public LinkedList<MatchCard> Deck { get; private set; }

    public List<MatchCard> Hand { get; }
    public List<MatchCard> DiscardPile { get; set; }

    public Player(GameMatch match, string name, int idx, Dictionary<string, int> landscapeIndex, LinkedList<MatchCard> deck, IPlayerController controller) {
        _match = match;
        Name = name;
        Idx = idx;
        Controller = controller;
        Deck = deck;
        _landscapeIndex = landscapeIndex;

        Hand = new();
        DiscardPile = new();
    }

    public string LogFriendlyName => $"{Name} [{Idx}]";

    public async Task ResetActionPoints() {
        ActionPoints = _match.Config.ActionPointsPerTurn;
        // TODO? add update
    }

    public async Task ReadyInPlayCards() {
        foreach (var lane in Landscapes) {
            if (lane.Creature is not null) {
                await _match.ReadyCard(lane.Creature);
            }
            if (lane.Building is not null) {
                await _match.ReadyCard(lane.Building);
            }
        }
    }

    public int Draw(int amount) {
        int drawn = 0;
        for (int i = 0; i < amount; i++) {
            if (Deck.Count == 0) {
                _match.LogInfo($"Player {LogFriendlyName} tried to draw out of an empty deck");
                break;
            }

            var card = Deck.Last!.Value;
            Deck.RemoveLast();
            Hand.Add(card);
            // TODO? add to update

            drawn++;
        }

        _match.LogInfo($"Player {LogFriendlyName} drew {drawn} cards");

        return drawn;
    }

    public void PayActionPoints(int amount) {
        ActionPoints -= amount;        
        if (ActionPoints < 0) {
            _match.LogError($"Player payed {amount} ap, which resulted in their ap being equal to {ActionPoints}");
        }
        // TODO? add update
    }

    public void PayToPlay(MatchCard card) {
        // TODO pay additional costs
        
        PayActionPoints(card.Template.Cost);
    }

    public void RemoveFromHand(MatchCard card) {
        // TODO? add to update

        Hand.Remove(card);
    }

    public void AddToDiscard(MatchCard card) {
        DiscardPile.Add(card);
    }

    public Task<int> ProcessDamage(int amount) {
        var result = Life;
        Life -= amount;
        if (Life < 0) Life = 0;

        result -= Life;

        _match.LogInfo($"Player {LogFriendlyName} was dealt {result} damage");

        return Task.FromResult(result);
    }

    public async Task Setup() {
        Life = _match.Config.StartingLifeTotal;
        await PlaceLandscapes();

        Deck = Common.Shuffled(Deck, _match.Rng);
        Draw(_match.Config.StartHandSize);
    }

    private async Task PlaceLandscapes() {
        var result = await Controller.PromptLandscapePlacement(this, _landscapeIndex);
        
        // TODO validate landscape choice
        
        for (int i = 0; i < result.Count; i++) {
            var landscape = new Landscape(result[i], i);
            Landscapes.Add(landscape);
        }
    }

    public Task PlaySpellEffect(MatchCard card) {
        card.ExecFunction(MatchCard.SPELL_EFFECT_FNAME, card.Data, Idx);
        return Task.CompletedTask;
    }

    public async Task<int> PickLaneForCreature() {
        var result = await Controller.PickLaneForCreature(_match, this);
        return result;
    }

    public async Task<int> PickLaneForBuilding() {
        var result = await Controller.PickLaneForBuilding(_match, this);
        return result;
    }

    public async Task<int> PickAttackLane(List<int> options) {
        var result = await Controller.PickAttackLane(_match, this, options);
        return result;
    }

    public Task PlaceCreatureInLane(MatchCard card, int laneI) {
        var lane = Landscapes[laneI];
        var creature = new Creature(card, Idx);

        if (lane.Creature is not null) {
            // TODO add creature replacement
        }

        lane.Creature = creature;
        creature.Card.ExecFunction(InPlayCard.ON_ENTER_PLAY_FNAME, creature.Card.Data, Idx, laneI);
        // TODO add triggers

        return Task.CompletedTask;
    }

    public Task PlaceBuildingInLane(MatchCard card, int laneI) {
        var lane = Landscapes[laneI];
        var building = new InPlayCard(card, Idx);

        if (lane.Building is not null) {
            // TODO ???
        }

        lane.Building = building;
        building.Card.ExecFunction(InPlayCard.ON_ENTER_PLAY_FNAME, building.Card.Data, Idx, laneI);
        // TODO add triggers

        return Task.CompletedTask;
    }

    public async Task<int[]> PickLandscape(List<int> options, List<int> opponentOptions, string hint) {
        var result = await Controller.PickLandscape(_match, this, options, opponentOptions, hint);
        return result;
    }

    public async Task<string> PickCreature(List<string> options, string hint) {
        var result = await Controller.PickCreature(_match, this, options, hint);
        return result;
    }
}
