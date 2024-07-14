using System.Linq.Expressions;
using System.Reflection;
using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Utility;

using NLua;

namespace CWCore.Match.Scripts;

public class ScriptMaster {
    private readonly GameMatch _match;
    public ScriptMaster(GameMatch match) {
        _match = match;

        // load all methods into the Lua state
        var type = typeof(ScriptMaster);
        foreach (var method in type.GetMethods())
        {
            if (method.GetCustomAttribute(typeof(LuaCommand)) is not null)
            {
                _match.LState[method.Name] = method.CreateDelegate(Expression.GetDelegateType(
                    (from parameter in method.GetParameters() select parameter.ParameterType)
                    .Concat(new[] { method.ReturnType })
                .ToArray()), this);
            }
        }
    }


    [LuaCommand]
    public void LogInfo(string msg) {
        _match.LogInfo(msg);
    }

    [LuaCommand]
    public string PlayerLogFriendlyName(int playerI) {
        return _match.GetPlayer(playerI).LogFriendlyName;
    }

    [LuaCommand]
    public int Draw(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        var result = player.Draw(amount)
            .GetAwaiter().GetResult();
        return result;
    }

    [LuaCommand]
    public int DrawFromBottom(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        var result = player.DrawFromBottom(amount)
            .GetAwaiter().GetResult();
        return result;
    }

    [LuaCommand]
    public int GetHandCount(int playerI) {
        var player = _match.GetPlayer(playerI);
        return player.Hand.Count;
    }

    [LuaCommand]
    public int DealDamageToPlayer(int playerI, int amount) {
        var dealt = _match.DealDamageToPlayer(playerI, amount)
            .GetAwaiter().GetResult();
        return dealt;
    }

    [LuaCommand]
    public LuaTable GetCreatures(int playerI) {
        var player = _match.GetPlayerState(playerI);

        var result = new List<CreatureState>();
        foreach (var lane in player.Landscapes) {
            if (lane.Creature is null) continue;

            result.Add(lane.Creature);
        }

        return LuaUtility.CreateTable(_match.LState, result);
    }

    [LuaCommand]
    public CreatureState GetCreature(string ipid) {
        var result = _match.GetInPlayCreature(ipid);
        return result;
    }

    [LuaCommand]
    public InPlayCardState GetBuilding(string ipid) {
        var result = _match.GetInPlayBuilding(ipid);
        return result;
    }

    [LuaCommand]
    public CreatureState? GetCreatureOrDefault(string ipid) {
        var result = _match.GetInPlayCreatureOrDefault(ipid);
        return result;
    }

    [LuaCommand]
    public InPlayCardState? GetBuildingOrDefault(string ipid) {
        var result = _match.GetInPlayBuildingOrDefault(ipid);
        return result;
    }

    [LuaCommand]
    public void DealDamageToCreature(string creatureIPID, int amount, LuaTable sourceTable) {
        var creature = _match.GetInPlayCreature(creatureIPID);
        _match.DealDamageToCreature(creature, amount, sourceTable)
            .Wait();
    }

    [LuaCommand]
    public void AddActionPoints(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        player.ActionPoints += amount;
        // TODO? add update
    }

    [LuaCommand]
    public void FloopCard(string ipid) {
        var card = _match.GetInPlayCard(ipid); 
        _match.FloopCard(card)
            .Wait();
    }

    [LuaCommand]
    public LuaTable GetPlayers() {
        return LuaUtility.CreateTable(_match.LState, _match.LastState.Players.ToList());
    }

    [LuaCommand]
    public int GetCurPlayerI() {
        return _match.CurPlayerI;
    }

    [LuaCommand]
    public PlayerState GetPlayer(int playerI) {
        return _match.GetPlayerState(playerI);
    }

    [LuaCommand]
    public void TurnLandscapeFaceDown(int playerI, int laneI) {
        var player = _match.GetPlayerState(playerI);
        var lane = player.Landscapes[laneI];
        _match.TurnLandscapeFaceDown(lane)
            .Wait();
    }

    [LuaCommand]
    public void TurnLandscapeFaceUp(int playerI, int laneI) {
        var player = _match.GetPlayerState(playerI);
        var lane = player.Landscapes[laneI];
        _match.TurnLandscapeFaceUp(lane)
            .Wait();
    }

    [LuaCommand]
    public int ChooseLane(int playerI, LuaTable optionsTable, string hint) {
        var player = _match.GetPlayerState(playerI);

        var options = new List<int>();
        foreach (var v in optionsTable.Values)
            options.Add(Convert.ToInt32(v));

        var result = player.Original.PickLane(options, hint)
            .GetAwaiter().GetResult();

        return result;
    }

    [LuaCommand]
    public string ChooseCreature(int playerI, LuaTable optionsTable, string hint) {
        var player = _match.GetPlayerState(playerI);

        var options = new List<string>();
        foreach (var v in optionsTable.Values)
            options.Add(v.ToString()!);

        var result = player.Original.PickCreature(options, hint)
            .GetAwaiter().GetResult();

        return result;
    }

    [LuaCommand]
    public string ChooseBuilding(int playerI, LuaTable optionsTable, string hint) {
        var player = _match.GetPlayerState(playerI);

        var options = new List<string>();
        foreach (var v in optionsTable.Values)
            options.Add(v.ToString()!);

        var result = player.Original.PickBuilding(options, hint)
            .GetAwaiter().GetResult();

        return result;
    }

    [LuaCommand]
    public void MoveCreature(string creatureIPID, int toI) {
        _match.MoveCreature(creatureIPID, toI)
            .Wait();
    } 

    [LuaCommand]
    public void MoveBuilding(string buildingIPID, int toI) {
        _match.MoveBuilding(buildingIPID, toI)
            .Wait();
    } 

    [LuaCommand]
    public int[] ChooseLandscape(int playerI, LuaTable optionsTable, LuaTable opponentOptionsTable, string hint) {
        var player = _match.GetPlayerState(playerI);

        var options = new List<int>();
        foreach (var v in optionsTable.Values)
            options.Add(Convert.ToInt32(v));

        var opponentOptions = new List<int>();
        foreach (var v in opponentOptionsTable.Values)
            opponentOptions.Add(Convert.ToInt32(v));

        var result = player.Original.PickLandscape(options, opponentOptions, hint)
            .GetAwaiter().GetResult();

        if (playerI == 1)
            result[0] = 1 - result[0];

        return result;
    }

    [LuaCommand]
    public string TargetCreature(int playerI, LuaTable optionsTable, string hint) {
        // TODO? should be different
        return ChooseCreature(playerI, optionsTable, hint);
    }

    [LuaCommand]
    public string TargetBuilding(int playerI, LuaTable optionsTable, string hint) {
        // TODO? should be different
        return ChooseBuilding(playerI, optionsTable, hint);
    }

    [LuaCommand] 
    public void PayActionPoints(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        player.ActionPoints -= amount;
        if (player.ActionPoints < 0)
            throw new GameMatchException($"action point payement resulted in a player's action point total being equal to {player.ActionPoints}");
        // TODO? add update
    }

    [LuaCommand]
    public void UntilEndOfTurn(LuaFunction modifier) {
        _match.UEOTEffects.Add(modifier);
    }

    [LuaCommand]
    public void AtTheEndOfTurn(LuaFunction trigger) {
        _match.AEOTEffects.Add(trigger);
    }

    [LuaCommand]
    public LuaTable GetUniqueLandscapeNames(int playerI) {
        var result = new HashSet<string>();

        var player = _match.GetPlayerState(playerI);
        foreach (var landscape in player.Landscapes) {
            if (landscape.Original.FaceDown) continue;

            result.Add(landscape.GetName());
        }

        return LuaUtility.CreateTable(_match.LState, result.ToList());
    }

    [LuaCommand]
    public bool YesNo(int playerI, string hint) {
        var player = _match.GetPlayer(playerI);
        var result = player.Pick(new List<string>() {
            "Yes", "No"
        }, hint)
            .GetAwaiter().GetResult();
        return result == "Yes";
    }

    [LuaCommand]
    public string PickString(int playerI, LuaTable optionsTable, string hint) {
        var player = _match.GetPlayer(playerI);

        List<string> options = new();
        foreach (var v in optionsTable.Values)
            options.Add((string)v);

        var result = player.Pick(options, hint)
            .GetAwaiter().GetResult();

        return result;
    }

    [LuaCommand]
    public void ReadyCard(string ipid) {
        var card = _match.GetInPlayCard(ipid);
        _match.ReadyCard(card.Original)
            .Wait();
    }

    [LuaCommand]
    public void UpdateState() {
        _match.ReloadState()
            .Wait();
    }

    [LuaCommand]
    public void SoftUpdateState() {
        _match.SoftReloadState()
            .Wait();
    }

    [LuaCommand]
    public int ChooseCardInHand(int playerI, LuaTable optionsTable, string hint) {
        List<int> options = new();
        foreach (var v in optionsTable.Values)
            options.Add(Convert.ToInt32(v));

        var player = _match.GetPlayer(playerI);
        var result = player.PickCardInHand(options, hint)
            .GetAwaiter().GetResult();

        return result;
    }

    [LuaCommand]
    public void DiscardFromHand(int playerI, int cardI) {
        var player = _match.GetPlayer(playerI);
        player.DiscardCardFromHand(cardI)
            .Wait();
    }

    [LuaCommand]
    public void ReturnCreatureToOwnersHand(string ipid) {
        var creature = _match.GetInPlayCreature(ipid);
        creature.ReturnToOwnersHand(_match)
            .Wait();
    }

    [LuaCommand]
    public int GetHitPoints(int playerI) {
        return _match.GetPlayer(playerI).Life;
    }

    [LuaCommand]
    public void HealHitPoints(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        player.HealHitPoints(amount)
            .Wait();
    }

    [LuaCommand]
    public void HealDamage(string creatureIPID, int amount) {
        var creature = _match.GetInPlayCreature(creatureIPID);
        _match.HealDamage(creature, amount)
            .Wait();
    }

    [LuaCommand]
    public void LoseHitPoints(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        player.LoseHitPoints(amount)
            .Wait();
    }

    [LuaCommand]
    public MatchConfig GetConfig() {
        return _match.Config;
    }

    [LuaCommand]
    public void PlaceTokenOnLandscape(int playerI, int laneI, string token) {
        _match.PlaceTokenOnLandscape(playerI, laneI, token)
            .Wait();
    }

    [LuaCommand]
    public int[] ChooseCardInDiscard(int playerI, LuaTable optionsTable, LuaTable opponentOptionsTable, string hint) {
        var player = _match.GetPlayerState(playerI);

        var options = new List<int>();
        foreach (var v in optionsTable.Values)
            options.Add(Convert.ToInt32(v));

        var opponentOptions = new List<int>();
        foreach (var v in opponentOptionsTable.Values)
            opponentOptions.Add(Convert.ToInt32(v));

        var result = player.Original.PickCardInDiscard(options, opponentOptions, hint)
            .GetAwaiter().GetResult();

        if (playerI == 1)
            result[0] = 1 - result[0];

        return result;
    }

    [LuaCommand]
    public void PlaceFromDiscardOnTopOfDeck(int playerI, int cardI) {
        var player = _match.GetPlayer(playerI);
        player.PlaceFromDiscardOnTopOfDeck(cardI);
    }

    [LuaCommand]
    public void SwapCreatures(string ipid1, string ipid2) {
        _match.SwapCreatures(ipid1, ipid2)
            .Wait();
    }

    [LuaCommand]
    public LuaTable Mill(int playerI, int amount) {
        var player = _match.GetPlayer(playerI);
        var result = player.Mill(amount);
        return LuaUtility.CreateTable(_match.LState, result);
    }

    [LuaCommand]
    public void ReturnToHandFromDiscard(int playerI, int cardI) {
        var player = _match.GetPlayer(playerI);
        var card = player.DiscardPile[cardI];
        player.DiscardPile.Remove(card);
        player.Hand.Add(card);
    }

    [LuaCommand]
    public int Random(int from, int to) {
        return _match.Rng.Next(from, to);
    }

    [LuaCommand]
    public bool DestroyBuilding(string ipid) {
        _match.DestroyBuilding(ipid)
            .Wait();
        return true;
    }

    [LuaCommand]
    public bool DestroyCreature(string ipid) {
        _match.DestroyCreature(ipid)
            .Wait();
        return true;
    }

    [LuaCommand]
    public ActivatedAbility DynamicActivatedAbility(LuaTable table) {
        return new ActivatedAbility(table);
    }

    [LuaCommand]
    public MatchCard RemoveCardFromHand(int playerI, int cardI) {
        var player = _match.GetPlayer(playerI);
        var card = player.Hand[cardI];
        player.Hand.RemoveAt(cardI);
        return card;
    }

    [LuaCommand]
    public void PlayCardIfPossible(int playerI, MatchCard card, bool forFree) {
        var player = _match.GetPlayerState(playerI);
        var cardState = new CardState(player, card);
        var canPlay = cardState.CanPlay(player, forFree);
        if (!canPlay) return;
        
        player.PlayCard(cardState, forFree)
            .Wait();
    }

    [LuaCommand]
    public void StealCreature(int fromPlayerI, string creatureIPID, int toLaneI) {
        _match.StealCreature(fromPlayerI, creatureIPID, toLaneI)
            .Wait();
    }

    [LuaCommand]
    public LuaTable RevealCardsFromDeck(int playerI, int amount) {
        var result = _match.RevealCardsFromDeck(playerI, amount)
            .GetAwaiter().GetResult();

        return LuaUtility.CreateTable(_match.LState, result);
    }

    [LuaCommand]
    public int ChooseCard(int playerI, LuaTable optionsTable, string hint) {

        List<string> options = new();
        foreach (var v in optionsTable.Values)
            options.Add((string)v);

        var player = _match.GetPlayer(playerI);
        var result = player.PickCard(options, hint)
            .GetAwaiter().GetResult();

        return result;
    }

    [LuaCommand]
    public void FromTopToBottom(int playerI, int amount) {
        var deck = _match.GetPlayer(playerI).Deck;
        if (deck.Count == 0) return;
        while (amount > 0) {
            var last = deck.Last!.Value;
            deck.RemoveLast();
            deck.AddFirst(last);
            amount--;
        }
    }

    [LuaCommand]
    public void UntilNextTurn(int playerI, LuaFunction effect) {
        var player = _match.GetPlayer(playerI);
        player.UntilNextTurnEffects.Add(effect);
    }

    [LuaCommand]
    public int TargetPlayer(int playerI, LuaTable optionsTable, string hint) {
        var player = _match.GetPlayerState(playerI);

        var options = new List<int>();
        foreach (var v in optionsTable.Values)
            options.Add(Convert.ToInt32(v));

        var result = player.Original.PickPlayer(options, hint)
            .GetAwaiter().GetResult();

        return result;
    }

    [LuaCommand]
    public void AddRestrictedActionPoint(int playerI, LuaFunction checkFunc) {
        _match.GetPlayer(playerI).RestrictedActionPoints.Add(new(checkFunc));
    }

    [LuaCommand]
    public void RevealCardFromHand(int playerI, int cardI) {
        _match.RevealCardsFromHand(playerI, cardI)
            .Wait();
    }

    [LuaCommand]
    public void RemoveFromDiscard(int playerI, int cardI) {
        var player = _match.GetPlayer(playerI);
        player.RemoveFromDiscard(cardI);
    }

    [LuaCommand]
    public string GetPhase() {
        return _match.PhaseName;
    }

    [LuaCommand]
    public void PlaceBuildingInLane(int playerI, int laneI, MatchCard card) {
        // TODO? this doesnt check if the card is a building or not

        var player = _match.GetPlayer(playerI);
        player.PlaceBuildingInLane(card, laneI)
            .Wait();
    }

    [LuaCommand]
    public CardState CreateState(int playerI, MatchCard card) {
        return new(_match.GetPlayerState(playerI), card);
    }

    [LuaCommand]
    public void PlaceCreature(int playerI, CardState card, bool forFree) {
        var player = _match.GetPlayerState(playerI);
        player.PlayCreature(card, forFree)
            .Wait();
    }

    [LuaCommand]
    public void PlaceBuilding(int playerI, CardState card, bool forFree) {
        var player = _match.GetPlayerState(playerI);
        player.PlayBuilding(card, forFree)
            .Wait();
    }

    [LuaCommand]
    public void AtTheStartOfNextTurn(int playerI, LuaFunction effect) {
        var player = _match.GetPlayer(playerI);
        player.AtTheStartOfNextTurnEffects.Add(effect);
    }

    [LuaCommand]
    public void FloatToTopOfDeck(int playerI, string cardID) {
        var deck = _match.GetPlayer(playerI).Deck;
        var card = deck.First(c => c.ID == cardID);
        deck.Remove(card);
        deck.AddLast(card);
    }

    [LuaCommand]
    public bool RemoveToken(int playerI, int laneI, string token) {
        var player = _match.GetPlayerState(playerI);
        var landscape = player.Landscapes[laneI];
        return landscape.Original.RemoveToken(token);
    }

    [LuaCommand]
    public LuaTable LandscapesAvailableForCreature(int playerI, CardState card) {
        var player = _match.GetPlayerState(playerI);
        var result = player.LandscapesAvailableForCreature(card);
        return LuaUtility.CreateTable(_match.LState, result);
    }

    [LuaCommand]
    public LuaTable LandscapesAvailableForBuilding(int playerI, CardState card) {
        var player = _match.GetPlayerState(playerI);
        var result = player.LandscapesAvailableForBuilding(card);
        return LuaUtility.CreateTable(_match.LState, result);
    }

    [LuaCommand]
    public bool DiscardFromPlay(string cardIPID) {
        var building = _match.GetInPlayBuilding(cardIPID);
        var player = _match.GetPlayerState(building.Original.Card.OwnerI);
        var landscape = _match.GetPlayerState(building.Original.ControllerI).Landscapes[building.LaneI];
        var removed = landscape.Original.Buildings.Remove(building.Original);

        if (!removed) {
            throw new GameMatchException($"tried to remove building with ipid {cardIPID} in landscape {landscape.GetName()} from play, where it is not present");
        }

        player.Original.LeavePlay(landscape, building)
            .Wait();
        return true;
    }

    [LuaCommand]
    public bool RemoveFromDeck(int playerI, int deckI) {
        var player = _match.GetPlayer(playerI);
        return player.Deck.Remove(player.Deck.ElementAt(deckI));
    }
}