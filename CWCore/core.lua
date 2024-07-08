-- TODO fix inconsistent casing - make all lua related stuff lowerCamelCase, all C# stuff already is CamelCase

STATE = {}

-- Core

Core = {}

-- Pipeline layer
Core.PipelineLayer = {}


-- Creates a new pipeline layer
function Core.PipelineLayer.New(delegate, id)
    local result = {delegate=delegate, id=id}
    return result
end


-- Pipeline creation object
Core.Pipeline = {}


-- Creates a new pipeline
function Core.Pipeline.New()
    local result = {
        layers = {},
        collectFunc = nil,
        collectInit = 0,
        result = 0
    }

    function result:AddLayer( delegate, id )
        id = id or nil
        self.layers[#self.layers+1] = Core.PipelineLayer.New(delegate, id)
    end

    function result:Exec( ... )
        self.result = self.collectInit
        for i, layer in ipairs(self.layers) do
            local returned, success = layer.delegate(...)
            if not success then
                return self.result, false
            end
            if self.collectFunc ~= nil then
                self.collectFunc(returned)
            end
        end
        return self.result, true
    end

    function result:Clear()
        self.layers = {}
    end

    function result:RemoveWithID( id )
        for i, layer in ipairs(self.layers) do
            if layer.id == id then
                table.remove(self.layers, i)
                return
            end
        end
        LogInfo('WARN: TRIED TO REMOVE LAYER WITH ID ' .. id ..' FROM TABLE, BUT FAILED')
    end

    return result
end

-- Card Wars

CardWars = {}

-- Phases

CardWars.Phases = {
    ACTION = 'turn_action',
    FIGHT = 'turn_fight',
    START = 'turn_start',
    END = 'turn_end',
}

-- Zones

CardWars.Zones = {
    DISCARD = 'discard',
    IN_PLAY = 'in_play',
    HAND = 'hand',
}

-- Triggers

CardWars.Triggers = {
    CREATURE_ENTER = 'creature_enter',
    DISCARD_FROM_HAND = 'discard_from_hand',
    CARD_DRAW = 'card_draw',
    TOKEN_PLACED_ON_LANDSCAPE = 'token_placed_on_landscape',
}

-- Landscapes

CardWars.Landscapes = {
    Rainbow = 'Rainbow',
    BluePlains = 'Blue Plains',
    SandyLands = 'SandyLands',
    Cornfield = 'Cornfield',
    NiceLands = 'NiceLands',
    UselessSwamp = 'Useless Swamp',
}

-- Modifiction layers

CardWars.ModificationLayers = {
    ATK_AND_DEF = 1,
    IN_PLAY_CARD_TYPE = 2,
    LANDSCAPE_TYPE = 3,
    CARD_COST = 4,
    ABILITY_GRANTING_REMOVAL = 5,
    LANDSCAPE_FLIP_DOWN_AVAILABILITY = 6,
    DAMAGE_MULTIPLICATION = 7,
    ATTACK_RIGHTS = 8,
    TARGETING_PERMISSIONS = 9,
    DAMAGE_MODIFICATION = 10,
    ADDITIONAL_LANDSCAPES = 11,
    IN_HAND_CARD_TYPE = 12,
    PLAY_RESTRICTIONS = 13,
    BUILDING_PLAY_LIMIT = 14,
    ENTER_PLAY_STATE = 15,
    READY_PRIVILEGES = 16,
    REPLACE_PRIVILEGES = 17,
}

-- Target sources

CardWars.TargetSources = {
    SPELL = 1,
    CREATURE_ABILITY = 2,
    BUILDING_ABILITY = 3,
    HERO_ABILITY = 4,
}

-- Damage sources

CardWars.DamageSources = {
    CREATURE = 1,
    SPELL = 2,
    CREATURE_ABILITY = 3,
    BUILDING_ABILITY = 4,
    HERO_ABILITY = 5,
}

-- Card Types

function CardWars:Hero()
    local result = {}

    result.StateModifiers = {}
    function result:AddStateModifier(modF)
        result.StateModifiers[#result.StateModifiers+1] = modF
    end

    result.ActivatedAbilities = {}
    function result:AddActivatedAbility(ability)
        ability.tags = ability.tags or {}
        ability.text = ability.text or 'MISSING HERO CARD ACTIVATED ABILITY TEXT'
        function ability:HasTag(tag)
            for _, t in ipairs(ability.tags) do
                if t == tag then
                    return true
                end
            end
            return false
        end

        ability.maxActivationsPerTurn = ability.maxActivationsPerTurn or -1
        result.ActivatedAbilities[#result.ActivatedAbilities+1] = ability
    end

    result.Triggers = {}
    function result:AddTrigger(trigger)
        result.Triggers[#result.Triggers+1] = trigger
    end

    return result
end

function CardWars:Card()
    local result = {}
    -- pipelines

    -- CanPlay pipeline
    result.CanPlayP = Core.Pipeline.New()
    result.CanPlayP:AddLayer(
        function (id, playerI)
            return nil, true
        end
    )
    function result:CanPlay(id, playerI)
        local _, res = self.CanPlayP:Exec(id, playerI)
        return res
    end

    -- -- PayCosts pipeline
    result.PayCostsP = Core.Pipeline.New()
    result.PayCostsP:AddLayer(
        function (playerI)
            return nil, true
        end
    )
    function result:PayCosts(playerI)
        local _, res = self.PayCostsP:Exec(playerI)
        return res
    end

    result.StateModifiers = {}

    function result:AddStateModifier(modF)
        result.StateModifiers[#result.StateModifiers+1] = modF
    end

    function result:ModifyState(me, layer, zone)
        for _, modF in ipairs(result.StateModifiers) do
            modF(me, layer, zone)
        end
    end

    return result
end

function CardWars:Spell()
    local result = CardWars:Card()

    result.EffectP = Core.Pipeline:New()

    function result:Effect(id, playerI)
        self.EffectP:Exec(id, playerI)
    end

    return result
end

function CardWars:InPlay()
    local result = CardWars:Card()

    result.ActivatedAbilities = {}
    function result:AddActivatedAbility(ability)
        ability.tags = ability.tags or {}
        ability.text = ability.text or 'MISSING CARD ACTIVATED ABILITY TEXT'
        function ability:HasTag(tag)
            for _, t in ipairs(ability.tags) do
                if t == tag then
                    return true
                end
            end
            return false
        end
        
        ability.maxActivationsPerTurn = ability.maxActivationsPerTurn or -1
        result.ActivatedAbilities[#result.ActivatedAbilities+1] = ability
    end

    result.Triggers = {}
    function result:AddTrigger(trigger)
        trigger.tags = trigger.tags or {}
        trigger.text = trigger.text or 'MISSING TRIGGERED ABILITY TEXT'
        result.Triggers[#result.Triggers+1] = trigger
    end

    result.EnterEffects = {}
    function result:OnEnter(effect)
        result.EnterEffects[#result.EnterEffects+1] = effect
    end

    result.LeaveEffects = {}
    function result:OnLeave(effect)
        result.LeaveEffects[#result.LeaveEffects+1] = effect
    end

    result.MoveEffects = {}
    function result:OnMove(effect)
        result.MoveEffects[#result.MoveEffects+1] = effect
    end


    return result
end

function CardWars:Creature()
    local result = CardWars:InPlay()

    result.DealDamageEffects = {}
    function result:OnDealDamage(effect)
        result.DealDamageEffects[#result.DealDamageEffects+1] = effect
    end

    result.DefeatedEffects = {}
    function result:OnDefeated(effect)
        result.DefeatedEffects[#result.DefeatedEffects+1] = effect
    end

    result.AttackEffects = {}
    function result:OnAttack(effect)
        result.AttackEffects[#result.AttackEffects+1] = effect
    end

    result.DamagedEffects = {}
    function result:OnDamaged(effect)
        result.DamagedEffects[#result.DamagedEffects+1] = effect
    end

    return result
end

-- Common

Common = {}

function Common.IDs(tableArr)
    local result = {}
    for _, card in ipairs(tableArr) do
        result[#result+1] = card.Original.Card.ID
    end
    return result
end

function Common.FilterCreatures(predicate)
    local result = {}
    for pi = 1, STATE.Players.Length do
        local pState = STATE.Players[pi - 1]
        for li = 1, pState.Landscapes.Count do
            local lane = pState.Landscapes[li - 1]
            if lane.Creature ~= nil then
                if predicate(lane.Creature) then
                    result[#result+1] = lane.Creature
                end
            end
        end
    end

    return result
end

function Common.FilterBuildings(predicate)
    local result = {}
    for pi = 1, STATE.Players.Length do
        local pState = STATE.Players[pi - 1]
        for li = 1, pState.Landscapes.Count do
            local lane = pState.Landscapes[li - 1]
            for bi = 0, lane.Buildings.Count - 1 do
                if predicate(lane.Buildings[bi]) then
                    result[#result+1] = lane.Buildings[bi]
                end
            end
        end
    end

    return result
end

function Common.FilterLandscapes(predicate)
    local result = {}

    for pi = 0, STATE.Players.Length - 1 do
        local pState = STATE.Players[pi]
        for li = 1, pState.Landscapes.Count do
            local lane = pState.Landscapes[li - 1]
            if predicate(lane) then
                result[#result+1] = lane
            end
        end
    end

    return result
end

function Common.Targetable(tableArr, by)
    local result = {}

    for _, card in ipairs(tableArr) do
        if card:CanBeTargetedBy(by) then
            result[#result+1] = card
        end
    end

    return result
end

function Common.TargetableBySpell(tableArr, ownerI, spellId)
    return Common.Targetable(tableArr, {
        type = CardWars.TargetSources.SPELL,
        ownerI = ownerI,
        spellId = spellId
    })
end

function Common.TargetableByCreature(tableArr, ownerI, creatureId)
    return Common.Targetable(tableArr, {
        type = CardWars.TargetSources.CREATURE_ABILITY,
        ownerI = ownerI,
        spellId = creatureId
    })
end

function Common.TargetableByBuilding(tableArr, ownerI, buildingId)
    return Common.Targetable(tableArr, {
        type = CardWars.TargetSources.BUILDING_ABILITY,
        ownerI = ownerI,
        spellId = buildingId
    })
end

function Common.TargetableByHero(tableArr, ownerI)
    return Common.Targetable(tableArr, {
        type = CardWars.TargetSources.HERO_ABILITY,
        ownerI = ownerI,
    })
end

function Common.CreaturesNamed(playerI, name)
    return Common.FilterCreatures( function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature.Original.Card.Template.Name == name
    end)
end

function Common.BuildingsNamed(playerI, name)
    return Common.FilterBuildings(function (building)
        return
            building.Original.ControllerI == playerI and
            building.Original.Card.Template.Name == name
    end)
end

function Common.CanFloop(card)
    if not GetConfig().CanFloopOnFirstTurn and STATE.TurnCount == 1 then
        return false
    end
    return card.Original:CanFloop()
end

function Common.FreezeLandscape(playerI, laneI)
    local landscape = STATE.Players[playerI].Landscapes[laneI]
    if landscape:IsFrozen() then
        return
    end
    PlaceTokenOnLandscape(playerI, laneI, 'Frozen')
end

function Common.GainDefense(creature, amount)
    local def = 0
    if amount > creature.Original.Damage then
        def = amount - creature.Original.Damage
        amount = creature.Original.Damage
    end

    HealDamage(creature.Original.Card.ID, amount)
    creature.Original.Defense = creature.Original.Defense + def
end

function Common.AdjacentLandscapes(playerI, laneI)
    local result = {}
    local lanes = STATE.Players[playerI].Landscapes
    if laneI - 1 >= 0 then
        result[#result+1] = lanes[laneI - 1]
    end
    if laneI + 1 < lanes.Count then
        result[#result+1] = lanes[laneI + 1]
    end

    return result
end

function Common.AdjacentLandscapesTyped(playerI, laneI, type)
    local result = {}

    local lanes = STATE.Players[playerI].Landscapes
    if laneI - 1 >= 0 and lanes[laneI - 1]:Is(type) then
        result[#result+1] = lanes[laneI - 1]
    end
    if laneI + 1 < lanes.Count and lanes[laneI + 1]:Is(type) then
        result[#result+1] = lanes[laneI + 1]
    end

    return result
end

function Common.AdjacentCreatures(playerI, laneI)
    local result = {}
    local adjacent = Common.AdjacentLandscapes(playerI, laneI)
    for _, landscape in ipairs(adjacent) do
        if landscape.Creature ~= nil then
            result[#result+1] = landscape.Creature
        end
    end
    return result
end

function Common.AdjacentBuildings(playerI, laneI)
    local result = {}
    local adjacent = Common.AdjacentLandscapes(playerI, laneI)
    for _, landscape in ipairs(adjacent) do
        for i = 0, landscape.Buildings.Count - 1 do
            result[#result+1] = landscape.Buildings[i]
        end
    end
    return result
end

function Common.AdjacentCreaturesTyped(playerI, laneI, type)
    local result = {}
    local adjacent = Common.AdjacentLandscapes(playerI, laneI)
    for _, landscape in ipairs(adjacent) do
        if landscape.Creature ~= nil and landscape.Creature:IsType(type) then
            result[#result+1] = landscape.Creature
        end
    end
    return result
end

function Common.LandscapesWithoutBuildings(playerI)
    return Common.FilterLandscapes(function (landscape)
        return landscape.Original.OwnerI == playerI and landscape.Buildings.Count == 0
    end)
end

function Common.LandscapesWithoutCreatures(playerI)
    return Common.FilterLandscapes(function (landscape)
        return landscape.Original.OwnerI == playerI and landscape.Creature == nil
    end)
end

function Common.EmptyLandscapes(playerI)
    return Common.LandscapesWithoutCreatures(playerI)
end

function Common.LandscapesWithoutCreaturesTyped(playerI, lType)
    return Common.FilterLandscapes(function (landscape)
        return
            landscape:Is(lType) and
            landscape.Original.OwnerI == playerI and
            landscape.Creature == nil
    end)
end

function Common.InPlay(playerI)
    local result = Common.Creatures(playerI)
    local buildings = Common.Buildings(playerI)

    for _, building in ipairs(buildings) do
        result[#result+1] = building
    end

    return result
end

function Common.Creatures(playerI)
    return Common.FilterCreatures(function (creature)
        return creature.Original.ControllerI == playerI
    end)
end

function Common.FriendlyCreatures(playerI)
    -- TODO? change if multiplayer will ever be implemented
    return Common.Creatures(playerI)
end

function Common.OwnedCreatures(playerI)
    return Common.FilterCreatures(function (creature)
        return creature.Original.Card.OwnerI == playerI
    end)
end

function Common.OpposingCreatures(playerI)
    return Common.Creatures(1 - playerI)
end

function Common.CreaturesExcept(playerI, id)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature.Original.Card.ID ~= id
    end)
end

function Common.Buildings(playerI)
    return Common.FilterBuildings(function (building)
        return building.Original.ControllerI == playerI
    end)
end

function Common.ReadiedCreatures(playerI)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature.Original:GetStatus() == 0
    end)
end

function Common.FloopedCreatures(playerI)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature.Original:IsFlooped()
    end)
end

function Common.ExhaustedCreatures(playerI)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature.Original:IsExhausted()
    end)
end

function Common.CreaturesTyped(playerI, landscape)
    return Common.CreaturesTypedExcept(playerI, landscape, '__empty_id__')
end

function Common.LandscapesWithBuildings(playerI)
    return Common.FilterLandscapes(function (landscape)
        return
            landscape.Original.OwnerI == playerI and
            landscape.Buildings.Count > 0
    end)
end

function Common.LandscapesTyped(playerI, type)
    local result = {}
    local landscapes = STATE.Players[playerI].Landscapes
    for i = 1, landscapes.Count do
        local landscape = landscapes[i - 1]
        if landscape:Is(type) then
            result[#result+1] = landscape
        end
    end
    return result
end

function Common.CountCreaturesThatCountAsLandscape(playerI, type)
    local creatures = Common.FilterCreatures(function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature.CountsAsLandscapes:Contains(type)
    end)
    local result = 0

    for _, c in ipairs(creatures) do
        for i = 0, c.CountsAsLandscapes.Count - 1 do
            local l = c.CountsAsLandscapes[i]
            if l == type then
                result = result + 1
            end
        end
    end

    return result
end

function Common.CountBuildingsThatCountAsLandscape(playerI, type)
    local buildings = Common.FilterBuildings(function (building)
        return
            building.Original.ControllerI == playerI and
            building.CountsAsLandscapes:Contains(type)
    end)
    local result = 0

    for _, c in ipairs(buildings) do
        for i = 0, c.CountsAsLandscapes.Count - 1 do
            local l = c.CountsAsLandscapes[i]
            if l == type then
                result = result + 1
            end
        end
    end

    return result
end

function Common.CountLandscapesTyped(playerI, type)
    local result = #Common.LandscapesTyped(playerI, type)

    result = result + Common.CountCreaturesThatCountAsLandscape(playerI, type)
    result = result + Common.CountBuildingsThatCountAsLandscape(playerI, type)

    return result
end

function Common.FaceDownLandscapes(playerI)
    local result = {}
    local landscapes = STATE.Players[playerI].Landscapes

    for i = 1, landscapes.Count do
        local landscape = landscapes[i - 1]
        if landscape.Original.FaceDown then
            result[#result+1] = landscape
        end
    end
    return result
end

function Common.FaceUpLandscapes(playerI)
    local result = {}
    local landscapes = STATE.Players[playerI].Landscapes

    for i = 1, landscapes.Count do
        local landscape = landscapes[i - 1]
        if not landscape.Original.FaceDown then
            result[#result+1] = landscape
        end
    end
    return result
end

function Common.AvailableToFlipDownLandscapes(landscapeOwnerI, byI)
    local landscapes = Common.FaceUpLandscapes(landscapeOwnerI)
    local result = {}
    for _, landscape in ipairs(landscapes) do
        if Common.Flip.CanFlipDown(landscape, byI) then
            result[#result+1] = landscape
        end
    end
    return result
end

function Common.AvailableToFlipDownLandscapesTyped(landscapeOwnerI, byI, type)
    local landscapes = Common.AvailableToFlipDownLandscapes(landscapeOwnerI, byI)
    local result = {}
    for _, landscape in ipairs(landscapes) do
        if landscape:Is(type) then
            result[#result+1] = landscape
        end
    end
    return result
end

function Common.CardsPlayedThisTurnTyped(playerI, landscape)
    local player = STATE.Players[playerI].Original

    local count = 0
    for i = 1, player.CardsPlayedThisTurn.Count do
        if player.CardsPlayedThisTurn[i - 1]:IsLandscape(landscape) then
            count = count + 1
        end
    end
    return count
end

function Common.SpellsPlayedThisTurnCount(playerI)
    local player = STATE.Players[playerI].Original

    local count = 0
    for i = 1, player.CardsPlayedThisTurn.Count do
        if player.CardsPlayedThisTurn[i - 1].Template.Type == 'Spell' then
            count = count + 1
        end
    end
    return count
end

function Common.CreaturesPlayedThisTurnCount(playerI)
    local player = STATE.Players[playerI].Original

    local count = 0
    for i = 1, player.CardsPlayedThisTurn.Count do
        if player.CardsPlayedThisTurn[i - 1].Template.Type == 'Creature' then
            count = count + 1
        end
    end
    return count
end

function Common.CreaturesTypedExcept(playerI, landscape, id)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature:IsType(landscape) and
            creature.Original.Card.ID ~= id
    end)
end

function Common.OpponentIdxs(playerI)
    return {1 - playerI}
end

function Common.CreaturesThatChangedLanes(playerI)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.ControllerI == playerI and
            creature.Original.MovementCount > 0
    end)
end

function Common.CreaturesWithNoDamage(playerI)
    local landscapes = STATE.Players[playerI].Landscapes
    local result = {}
    for i = 1, landscapes.Count do
        local landscape = landscapes[i - 1]
        local creature = landscape.Creature
        if creature ~= nil and creature.Original.Damage == 0 then
            result[#result+1] = creature
        end
    end
    return result
end

function Common.CreaturesWithBuildings(playerI)
    local result = {}
    local landscapes = Common.LandscapesWithBuildings(playerI)
    for _, landscape in ipairs(landscapes) do
        local creature = landscape.Creature
        if creature ~= nil then
            result[#result+1] = creature
        end
    end
    return result
end

function Common.LandscapesInLaneTyped(type, laneI)
    local result = {}
    for i = 1, 2 do
        local landscapes = STATE.Players[i - 1].Landscapes
        result[i] = {}

        if landscapes[laneI]:Is(type) then
            result[i] = {landscapes[laneI]}
        end
    end
    return result
end

function Common.LandscapesInLane(laneI)
    local result = {}
    for i = 1, 2 do
        local landscapes = STATE.Players[i - 1].Landscapes

        result[i] = {landscapes[laneI]}
    end
    return result
end

function Common.AvailableToFlipDownLandscapesInLaneTyped(playerI, type, laneI)
    local tuple = Common.LandscapesInLaneTyped(type, laneI)

    local result = {}
    for i, lanes in ipairs(tuple) do
        local t = {}
        for _, landscape in ipairs(lanes) do
            if Common.Flip.CanFlipDown(landscape, playerI) then
                t[#t+1] = landscape
            end
        end
        if playerI == 0 then
            result[i] = t
        else
            result[3 - i] = t
        end
    end

    return result
end

function Common.DiscardCardIdx(playerI, id)
    local discard = STATE.Players[playerI].DiscardPile
    for i = 0, discard.Count - 1 do
        if discard[i].Original.ID == id then
            return i
        end
    end
    return nil
end

function Common.HandCardIdx(playerI, id)
    local hand = STATE.Players[playerI].Hand
    for i = 0, hand.Count - 1 do
        if hand[i].Original.ID == id then
            return i
        end
    end
    return nil
end

function Common.ChooseAndDiscardCard(playerI, hint)
    hint = hint or 'Choose a card to discard'
    local cards = STATE.Players[playerI].Hand
    if cards.Count == 0 then
        return nil
    end

    local ids = {}
    for i = 1, cards.Count do
        ids[#ids+1] = i - 1
    end

    local result = ChooseCardInHand(playerI, ids, hint)
    local cardId = STATE.Players[playerI].Hand[result].Original.ID

    DiscardFromHand(playerI, result)

    return cardId
end

function Common.DiscardNCards(playerI, amount)
    -- TODO could be better
    for i = 1, amount do
        Common.ChooseAndDiscardCard(playerI)
        UpdateState()
    end
end

function Common.ControlBuildingInLane(playerI, laneI)
    return STATE.Players[playerI].Landscapes[laneI].Buildings.Count > 0
end

function Common.TargetOpponent(playerI)
    -- TODO? i don't think teams will be implemented, but just in case
    return 1 - playerI
end

function Common.FilterCardsInHandIndicies(playerI, predicate)
    local result = {}

    -- TODO move to filter function
    local cards = STATE.Players[playerI].Hand
    for i = 1, cards.Count do
        local card = cards[i - 1]
        if predicate(card) then
            result[#result+1] = i - 1
        end
    end

    return result
end

function Common.CardsInHandWithCostGreaterOrEqual(playerI, cost)
    return Common.FilterCardsInHandIndicies(playerI, function (card)
        return card:RealCost() >= cost
    end)
end

function Common.BuildingsInHand(playerI)
    return Common.FilterCardsInHandIndicies(playerI, function (card)
        return card.Original.Template.Type == 'Building'
    end)
end

function Common.DiscardPileCardIndicies(playerI, predicate)
    local discard = STATE.Players[playerI].DiscardPile
    local result = {}
    for i = 1, discard.Count do
        if predicate(discard[i - 1]) then
            result[#result+1] = i - 1
        end
    end
    return result
end

function Common.CreatureCardsIndiciesInDiscard(playerI)
    return Common.DiscardPileCardIndicies(playerI, function (card)
        return card.Original.Template.Type == 'Creature'
    end)
end

function Common.RandomCardInDiscard(playerI, predicate)
    local choices = Common.DiscardPileCardIndicies(playerI, predicate)
    if #choices == 0 then
        return nil
    end

    local res = Random(1, #choices + 1)
    return choices[res]
end

function Common.CreaturesInLane(playerI, laneI)
    local result = {}
    local player = STATE.Players[playerI]
    local lane = player.Landscapes[laneI]
    if lane.Creature ~= nil then
        result[#result+1] = lane.Creature
    end
    return result
end

function Common.BuildingsInLane(playerI, laneI)
    local result = {}
    local player = STATE.Players[playerI]
    local lane = player.Landscapes[laneI]
    for i = 0, lane.Buildings.Count - 1 do
        result[#result+1] = lane.Buildings[i]
    end
    return result
end

function Common.OpposingCreaturesInLane(playerI, laneI)
    local result = {}
    local player = STATE.Players[1 - playerI]
    local lane = player.Landscapes[laneI]
    if lane.Creature ~= nil then
        result[#result+1] = lane.Creature
    end
    return result

end

function Common.FloopAbilitiesOfCreaturesInDiscard(playerI)
    local result = {}
    local player = STATE.Players[playerI]
    for i = 0, player.DiscardPile.Count - 1 do
        local card = player.DiscardPile[i].Original
        if card.Template.Type == 'Creature' then
            local data = player.DiscardPile[i].Original.Data
            for _, aa in ipairs(data.ActivatedAbilities) do
                if aa:HasTag('floop') then
                    result[#result+1] = aa
                end
            end
        end
    end

    return result
end

function Common.UntilFightPhase(playerI, modF)
    -- TODO is this bad?
    UntilEndOfTurn(function (layer)
        if GetPhase() == CardWars.Phases.FIGHT then
            return
        end
        modF(layer)
    end)
end

function Common.SearchDeckFor(playerI, predicate)
    local deck = STATE.Players[playerI].Original:DeckAsList()
    local options = {}
    for i = 0, deck.Count - 1 do
        local card = deck[i]
        if predicate(card) then
            options[#options+1] = card.Template.Name
        end
    end
    if #options == 0 then
        return -1
    end
    local choice = ChooseCard(playerI, options, 'Choose a Building to put in play')
    local cardName = options[choice + 1]
    for i = 0, deck.Count - 1 do
        local card = deck[i]
        if card.Template.Name == cardName then
            return i
        end
    end
    error('Error in SearchDeckFor: tried to find card '..cardName..' in deck of player ['..playerI..'], but failed')
end

function Common.FrozenLandscapes(playerI)
    return Common.FilterLandscapes(function (landscape)
        return landscape:IsFrozen() and landscape.Original.OwnerI == playerI
    end)
end

function Common.SplitLandscapesByOwner(landscapes)
    local result = {}
    for i = 0, STATE.Players.Length - 1 do
        result[i] = {}
    end
    for _, landscape in ipairs(landscapes) do
        local idx = landscape.Original.OwnerI
        result[idx][#result[idx]+1] = landscape
    end
    return result
end

Common.AllPlayers = {}

function Common.AllPlayers.Landscapes()
    return Common.FilterLandscapes(function (_)
        return true
    end)
end

function Common.AllPlayers.CreaturesWithFrozenTokens()
    local landscapes = Common.AllPlayers.FrozenLandscapes()
    local result = {}
    for _, landscape in ipairs(landscapes) do
        result[#result+1] = landscape.Creature
    end
    return result
end

function Common.AllPlayers.FrozenLandscapes()
    return Common.FilterLandscapes(function (landscape)
        return landscape:IsFrozen()
    end)
end

function Common.AllPlayers.LandscapesWithoutCreatures()
    return Common.FilterLandscapes(function (landscape)
        return landscape.Creature == nil
    end)
end

function Common.AllPlayers.CreaturesTyped(landscape)
    return Common.FilterCreatures(function (creature)
        return
            creature:IsType(landscape)
    end)

end

function Common.AllPlayers.CreaturesInLane(laneI)
    return Common.AllPlayers.CreaturesInLaneExcept(laneI, '__empty_id__')
end

function Common.AllPlayers.CreaturesInLaneExcept(laneI, id)
    local result = {}
    local players = GetPlayers()

    for i = 1, 2 do
        local player = players[i]
        local lane = player.Landscapes[laneI]
        if lane.Creature ~= nil then
            local cid = lane.Creature.Original.Card.ID
            if cid ~= id then
                result[#result+1] = lane.Creature
            end
        end
    end

    return result
end

function Common.AllPlayers.BuildingsInLane(laneI)
    local result = {}
    local players = GetPlayers()

    for i = 1, 2 do
        local player = players[i]
        local lane = player.Landscapes[laneI]
        for bi = 0, lane.Buildings.Count - 1 do
            result[#result+1] = lane.Buildings[bi]
        end
    end

    return result
end

function Common.AllPlayers.LandscapesTyped(type)
    return Common.FilterLandscapes(function (landscape)
        return landscape:Is(type)
    end)
end

function Common.AllPlayers.CountLandscapesTyped(type)
    local result = #Common.AllPlayers.LandscapesTyped(type)

    for i = 0, 1 do
        result = result + Common.CountCreaturesThatCountAsLandscape(i, type)
        result = result + Common.CountBuildingsThatCountAsLandscape(i, type)
    end

    return result
end

function Common.AllPlayers.Creatures()
    return Common.FilterCreatures(function (_) return true end)
end

function Common.AllPlayers.CreaturesExcept(id)
    return Common.FilterCreatures(function (creature) return creature.Original.Card.ID ~= id end)
end

function Common.AllPlayers.Buildings()
    return Common.FilterBuildings(function (_) return true end)
end

function Common.AllPlayers.FloopedCreatures()
    return Common.FilterCreatures(function (creature)
        return creature.Original:IsFlooped()
    end)
end

function Common.AllPlayers.AvailableToFlipDownLandscapes(byI)
    return {
        Common.AvailableToFlipDownLandscapes(0, byI),
        Common.AvailableToFlipDownLandscapes(1, byI),
    }
end

Common.Mod = {}

function Common.Mod.Cost(me, amount)
    me.Cost = me.Cost + amount
    if me.Cost < 0 then
        me.Cost = 0
    end
end

function Common.Mod.ModNextCost(playerI, amount, predicate)
    Common.Mod.ModNextCostFunc(playerI, predicate, function (card)
        Common.Mod.Cost(card, amount)
    end)
end

function Common.Mod.ModNextCostFunc(playerI, predicate, modF)
    local rememberedIdx = STATE.Players[playerI].CardsPlayedThisTurn.Count
    UntilEndOfTurn(function (layer)
        if layer ~= CardWars.ModificationLayers.CARD_COST then
            return
        end

        local newPlayed = STATE.Players[playerI].CardsPlayedThisTurn
        if newPlayed.Count > rememberedIdx then
            for i = rememberedIdx, newPlayed.Count - 1 do
                local card = newPlayed[i]
                if predicate(card) then
                    return
                end
            end
        end

        local cards = STATE.Players[playerI].Hand
        for i = 0, cards.Count - 1 do
            local card = cards[i]
            if predicate(card) then
                modF(card)
            end
        end
    end)
end

Common.Triggers = {}

function Common.Triggers.AtTheStartOfYourPhase(card, phase, effect)
    card:AddTrigger({
        trigger = phase,
        checkF = function (me, controllerI, laneI, args)
            return args.playerI == controllerI
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = effect
    })
end

function Common.Triggers.AtTheStartOfYourTurn(card, effect)
    Common.Triggers.AtTheStartOfYourPhase(card, CardWars.Phases.START, effect)
end

function Common.Triggers.AtTheStartOfYourFightPhase(card, effect)
    Common.Triggers.AtTheStartOfYourPhase(card, CardWars.Phases.FIGHT, effect)
end

function Common.Triggers.OnAnotherCreatureEnterPlayUnderYourControl(card, effect)
    card:AddTrigger({
        trigger = CardWars.Triggers.CREATURE_ENTER,
        checkF = function (me, controllerI, laneI, args)
            return args.controllerI == controllerI and args.laneI ~= laneI
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = effect
    })
end

Common.ActivatedAbilities = {}

function Common.ActivatedAbilities.DestroyMe(card, text, effect)
    card:AddActivatedAbility({
        text = text,
        checkF = function (me, playerI, laneI)
            return true
        end,
        costF = function (me, playerI, laneI)
            return DestroyCreature(me.Original.Card.ID)
        end,
        effectF = effect
    })
end

function Common.ActivatedAbilities.DiscardFromPlay(card, text, effect)
    card:AddActivatedAbility({
        text = text,
        checkF = function (me, playerI, laneI)
            return true
        end,
        costF = function (me, playerI, laneI)
            return DiscardFromPlay(me.Original.Card.ID)
        end,
        effectF = effect
    })
end

function Common.ActivatedAbilities.Floop(card, text, effect)
    card:AddActivatedAbility({
        text = text,
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = effect
    })
end

function Common.ActivatedAbilities.WhileFlooped(card, text, stateModEffect)
    Common.ActivatedAbilities.Floop(
        card,
        text,
        function (me, playerI, laneI)
        end
    )

    card:AddStateModifier(stateModEffect)
end

function Common.ActivatedAbilities.PayActionPoints(card, amount, text, effect)
    card:AddActivatedAbility({
        text = text,
        checkF = function (me, playerI, laneI)
            return GetPlayer(playerI).Original.ActionPoints >= amount
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, amount)
            return true
        end,
        effectF = effect
    })
end

function Common.ActivatedAbilities.DiscardCard(card, text, effect, maxActivationsPerTurn)
    maxActivationsPerTurn = maxActivationsPerTurn or -1
    card:AddActivatedAbility({
        text = text,
        maxActivationsPerTurn = maxActivationsPerTurn,
        checkF = function (me, playerI, laneI)
            return GetHandCount(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            Common.ChooseAndDiscardCard(playerI)
            return true
        end,
        effectF = effect
    })
end

function Common.AddRestriction(card, restriction)
    card.CanPlayP:AddLayer(restriction)
end

Common.State = {}

function Common.State.ModATKDEF(card, effect)
    card:AddStateModifier(function (me, layer, zone)
        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            effect(me)
        end

    end)
end

function Common.State.ModCostInHand(card, effect)
    card:AddStateModifier(function (me, layer, zone)
        if layer == CardWars.ModificationLayers.CARD_COST and zone == CardWars.Zones.HAND then
            effect(me)
        end
    end)
end

function Common.State.ModAttackRight(card, effect)
    card:AddStateModifier(function (me, layer, zone)
        if layer == CardWars.ModificationLayers.ATTACK_RIGHTS and zone == CardWars.Zones.IN_PLAY then
            effect(me)
        end
    end)
end

function Common.State.CantBeAttacked(creature)
    local opponent = 1 - creature.Original.ControllerI
    local lane = STATE.Players[opponent].Landscapes[creature.LaneI]
    local c = lane.Creature
    if c == nil then
        return
    end
    -- TODO? split CanAttack and CanBeAttacked in CreatureState?
    Common.State.CantAttack(creature)
end

function Common.State.CantAttack(creature)
    creature.CanAttack = false
end

function Common.State.CantBeTargeted(inPlayCard, by)
    -- * by can be nil

    inPlayCard.CanBeTargetedCheckers:Add(function (table)
        return table.ownerI == by
    end)
end

function Common.State.ChangeLandscapeType(layer, cardID, to)
    if layer == CardWars.ModificationLayers.IN_HAND_CARD_TYPE then
        for playerI = 0, 1 do
            local hand = STATE.Players[playerI].Hand
            for i = 0, hand.Count - 1 do
                if hand[i].Original.ID == cardID then
                    hand[i].LandscapeType = CardWars.Landscapes.Rainbow
                    break
                end
            end
        end
        -- TODO cards in discard, cards in play, ?cards played this turn?, ?cards that entered play on a specific lane?
    end
end

function Common.State.WhileDefendingAgainst(card, againstPredicate, effect)
    card:AddStateModifier(function (me, layer, zone)
        if layer ~= CardWars.ModificationLayers.ATK_AND_DEF then
            return
        end
        if zone ~= CardWars.Zones.IN_PLAY then
            return
        end
        if GetPhase() ~= CardWars.Phases.FIGHT then
            return
        end
        local playerI = me.Original.ControllerI
        if GetCurPlayerI() == playerI then
            return
        end

        local against = STATE.Players[1 - playerI].Landscapes[me.LaneI].Creature
        if against == nil then
            return
        end

        if not against.Original.Attacking then
            return
        end

        if not againstPredicate(against) then
            return
        end

        effect(me)
    end)
end

function Common.State.WhileAttackingCreature(card, defenderPredicate, effect)
    card:AddStateModifier(function (me, layer, zone)
        if layer ~= CardWars.ModificationLayers.ATK_AND_DEF then
            return
        end

        if zone ~= CardWars.Zones.IN_PLAY then
            return
        end

        if GetPhase() ~= CardWars.Phases.FIGHT then
            return
        end

        local playerI = me.Original.ControllerI
        if GetCurPlayerI() ~= playerI then
            return
        end

        if not GetCreature(me.Original.Card.ID).Original.Attacking then
            return
        end

        local defender = STATE.Players[1 - playerI].Landscapes[me.LaneI].Creature
        if defender == nil then
            return
        end


        if not defenderPredicate(defender) then
            return
        end

        effect(me)
    end)
end

Common.AbilityGrantingRemoval = {}

function Common.AbilityGrantingRemoval.RemovaAllFromBuilding(card)
    card.ActivatedAbilities:Clear()
    card.TriggeredAbilities:Clear()
    card.StateModifiers:Clear()
    card.OnMoveEffects:Clear()
    card.OnEnterEffects:Clear()
    card.OnLeaveEffects:Clear()
end

function Common.AbilityGrantingRemoval.RemovaAllFromCreature(card)
    Common.AbilityGrantingRemoval.RemovaAllFromBuilding(card)

    card.OnDealDamageEffects:Clear()
    card.OnDamagedEffects:Clear()
    card.OnAttackEffects:Clear()
    card.OnDefeatedEffects:Clear()
end

function Common.AbilityGrantingRemoval.RemoveAllActivatedAbilities(card)
    card.ActivatedAbilities:Clear()
end

function Common.AbilityGrantingRemoval.CopyFromBuilding(card, from)
    card.ActivatedAbilities:AddRange(from.ActivatedAbilities)
    card.TriggeredAbilities:AddRange(from.TriggeredAbilities)
    card.StateModifiers:AddRange(from.StateModifiers)
    card.OnMoveEffects:AddRange(from.OnMoveEffects)
    card.OnEnterEffects:AddRange(from.OnEnterEffects)
    card.OnLeaveEffects:AddRange(from.OnLeaveEffects)
end

Common.Flip = {}

function Common.Flip.CanFlipDown(landscape, playerI)
    return landscape.CanFlipDown:Contains(playerI)
end

function Common.Flip.DisallowFlipDownFor(landscape, playerI)
    local allowed = landscape.CanFlipDown
    allowed:Remove(playerI)
end

Common.Damage = {}

function Common.Damage.ToCreatureBySpell(spellId, ownerI, creatureId, amount)
    DealDamageToCreature(creatureId, amount, {
        type = CardWars.DamageSources.SPELL,
        id = spellId,
        ownerI = ownerI
    })
end

function Common.Damage.ToCreatureByHero(playerI, creatureId, amount)
    DealDamageToCreature(creatureId, amount, {
        type = CardWars.DamageSources.SPELL,
        playerI = playerI
    })
end

function Common.Damage.ToCreatureByBuildingAbility(buildingId, ownerI, creatureId, amount)
    DealDamageToCreature(creatureId, amount, {
        type = CardWars.DamageSources.BUILDING_ABILITY,
        id = buildingId,
        ownerI = ownerI
    })
end

function Common.Damage.ToCreatureByCreatureAbility(fromId, controllerI, toId, amount)
    DealDamageToCreature(toId, amount, {
        type = CardWars.DamageSources.CREATURE_ABILITY,
        ownerI = controllerI,
        id = fromId
    })
end

function Common.Damage.ToCreatureByCreature(fromId, controllerI, toId, amount)
    DealDamageToCreature(toId, amount, {
        type = CardWars.DamageSources.CREATURE,
        ownerI = controllerI,
        id = fromId
    })
end

function Common.Damage.PreventCreatureDamage(creature)
    creature.DamageModifiers:Add(function (me, from, damage)
        if
            from.type == CardWars.DamageSources.CREATURE and
            from.ownerI ~= me.Original.ControllerI
        then
            return 0
        end
        return damage
    end)
end

Common.Bounce = {}

function Common.Bounce.ReturnToHandAndPlayForFree(playerI, id)
    ReturnCreatureToOwnersHand(id)
    UpdateState()

    local idx = Common.HandCardIdx(playerI, id)
    local card = STATE.Players[playerI].Hand[idx]

    PlayCardIfPossible(playerI, card.Original, true)
end

Common.Freeze = {}

function Common.Freeze.TargetLandscape(playerI)
    local landscapes = Common.SplitLandscapesByOwner(Common.AllPlayers.Landscapes())
    local l1 = CW.Lanes(landscapes[playerI])
    local l2 = CW.Lanes(landscapes[1 - playerI])
    local choice = ChooseLandscape(playerI, l1, l2, 'Choose a Landscape to freeze')
    Common.FreezeLandscape(choice[0], choice[1])
end

Common.Reveal = {}

function Common.Reveal.Hand(playerI)
    local handCount = STATE.Players[playerI].Original.Hand.Count
    for i = 0, handCount - 1 do
        RevealCardFromHand(playerI, i)
    end
end

CW = {}

function CW.FilterCreatures(filter)
    local result = {}
    for pi = 1, STATE.Players.Length do
        local pState = STATE.Players[pi - 1]
        for li = 1, pState.Landscapes.Count do
            local lane = pState.Landscapes[li - 1]
            if lane.Creature ~= nil then
                if filter == nil or filter(lane.Creature) then
                    result[#result+1] = lane.Creature
                end
            end
        end
    end
    return result
end

function CW.FilterLandscapes(filter)
    local result = {}

    for pi = 0, STATE.Players.Length - 1 do
        local pState = STATE.Players[pi]
        for li = 1, pState.Landscapes.Count do
            local landscape = pState.Landscapes[li - 1]
            if filter == nil or filter(landscape) then
                result[#result+1] = landscape
            end
        end
    end

    return result
end

function CW.Creatures(playerI)
    return CW.FilterCreatures(function (creature)
        return playerI == nil or creature.Original.ControllerI == playerI
    end)
end

function CW.CreaturesThatEnteredPlayThisTurn()
    local landscapes = CW.FilterLandscapes()
    local result = {}

    for _, landscape in ipairs(landscapes) do
        for i = 0, landscape.Original.CreaturesEnteredThisTurn.Count - 1 do
            result[#result+1] = landscape.Original.CreaturesEnteredThisTurn[i]
        end
    end

    return result
end

function CW.SplitLandscapesByOwner(landscapes)
    local result = {}
    for i = 0, STATE.Players.Length - 1 do
        result[i] = {}
    end
    for _, landscape in ipairs(landscapes) do
        local idx = landscape.Original.OwnerI
        result[idx][#result[idx]+1] = landscape
    end
    return result
end

function CW.Lanes(landscapes)
    local result = {}
    for _, landscape in ipairs(landscapes) do
        result[#result+1] = landscape.Original.Idx
    end
    return result
end

function CW.CreatureFilter()
    local result = {}

    result.filters = {}

    function result:Do()
        local filter = function (creature)
            for _, f in ipairs(result.filters) do
                if not f(creature) then
                    return false
                end
            end
            return true
        end
        return CW.FilterCreatures(filter)
    end

    function result:OwnedBy(playerI)
        result.filters[#result.filters+1] = function (creature)
            return creature.Original.Card.OwnerI == playerI
        end
        return self
    end

    function result:ControlledBy(playerI)
        result.filters[#result.filters+1] = function (creature)
            return creature.Original.Card.OwnerI == playerI
        end
        return self
    end

    function result:AdjacentToLane(laneI)
        result.filters[#result.filters+1] = function (creature)
            return creature.LaneI == laneI - 1 or creature.LaneI == laneI + 1
        end
        return self
    end

    function result:NotControlledBy(playerI)
        result.filters[#result.filters+1] = function (creature)
            return creature.Original.Card.OwnerI ~= playerI
        end
        return self
    end

    function result:InLane(laneI)
        result.filters[#result.filters+1] = function (creature)
            return creature.LaneI == laneI
        end
        return self
    end

    return result
end

function CW.LandscapeFilter()
    local result = {}

    result.filters = {}

    function result:Do()
        local filter = function (landscape)
            for _, f in ipairs(result.filters) do
                if not f(landscape) then
                    return false
                end
            end
            return true
        end
        return CW.FilterLandscapes(filter)
    end

    function result:OwnedBy(playerI)
        result.filters[#result.filters+1] = function (landscape)
            return landscape.Original.OwnerI == playerI
        end
        return self
    end

    function result:OnLane(laneI)
        result.filters[#result.filters+1] = function (landscape)
            return landscape.Original.Idx == laneI
        end
        return self
    end

    function result:CanBeFlippedDown(byI)
        result.filters[#result.filters+1] = function (landscape)
            return landscape.CanFlipDown:Contains(byI)
        end
        return self
    end

    return result
end

function CW.SpellTargetCreature(card, creatureFilterFunc, targetHint, effectF)
    Common.AddRestriction(card,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(creatureFilterFunc(id, playerI), playerI, id) > 0
        end
    )

    card.EffectP:AddLayer(
        function (id, playerI)
            local ids = Common.IDs(Common.TargetableBySpell(creatureFilterFunc(id, playerI), playerI, id))
            local target = TargetCreature(playerI, ids, targetHint)
            local creature = GetCreature(target)
            effectF(id, playerI, creature)
        end
    )
end

CW.Target = {}

function CW.Target.Landscape(options, byPlayerI)
    local split = CW.SplitLandscapesByOwner(options)
    local l1 = CW.Lanes(split[0])
    local l2 = CW.Lanes(split[1])
    if byPlayerI == 1 then
        l1, l2 = l2, l1
    end
    if (#l1 + #l2) == 0 then
        return nil
    end
    local choice = ChooseLandscape(byPlayerI, l1, l2, 'Choose a Cornfield Landscape to flip face-down')
    return STATE.Players[choice[0]].Landscapes[choice[1]]
end

CW.Creature = {}

function CW.Creature.ParrottrooperEffect(card, thenEffect)
    card:OnEnter(function(me, playerI, laneI, replaced)
        -- When  enters play, 

        local landscapes = Common.AllPlayers.LandscapesWithoutCreatures()
        local myLanes = {}
        local opponentsLanes = {}
        for _, landscape in ipairs(landscapes) do
            if landscape.Original.OwnerI == playerI then
                myLanes[#myLanes+1] = landscape
            else
                opponentsLanes[#opponentsLanes+1] = landscape
            end
        end
        if #myLanes + #opponentsLanes == 0 then
            return
        end
        local lane = ChooseLandscape(playerI, CW.Lanes(myLanes), CW.Lanes(opponentsLanes), 'Choose a landscape to move '..me.Original.Card.Template.Name..' to')
        local toPlayerI = lane[0]
        local toLaneI = lane[1]
        if toPlayerI == playerI then
            MoveCreature(me.Original.Card.ID, toLaneI)
            return
        end
        StealCreature(playerI, me.Original.Card.ID, toLaneI)

        if thenEffect == nil then
            return
        end

        thenEffect(me)
    end)

    card:AddStateModifier(function (me, layer, zone)
        -- ... It cannot be replaced. ...

        if layer == CardWars.ModificationLayers.REPLACE_PRIVILEGES and zone == CardWars.Zones.IN_PLAY then
            me.CanBeReplaced = false
        end
    end)
end

RockNRollerEffectMemory = {}

function CW.Creature.RockNRollerEffect(card)

    card:OnEnter(function(me, playerI, laneI, replaced)
        -- When Rock 'n Roller enters play, flip a Landscape in this Lane face down.

        local landscape = CW.Target.Landscape(
            CW.LandscapeFilter():OnLane(laneI):CanBeFlippedDown(playerI):Do(),
            playerI
        )
        if landscape == nil then
            return
        end
        RockNRollerEffectMemory[me.Original.Card.ID] = landscape
        CW.Landscape.FlipDown(landscape.Original.OwnerI, landscape.Original.Idx)

    end)

    card:OnLeave(function(id_, playerI_, laneI_, wasReady_)
        -- When Rock 'n Roller leaves play, flip it face up.
        local landscape = RockNRollerEffectMemory[id_]
        if landscape == nil then
            return
        end
        CW.Landscape.FlipUp(landscape.Original.OwnerI, landscape.Original.Idx)
    end)

end

CW.Landscape = {}

function CW.Landscape.FlipDown(playerI, laneI)
    TurnLandscapeFaceDown(playerI, laneI)
end

function CW.Landscape.FlipUp(playerI, laneI)
    TurnLandscapeFaceUp(playerI, laneI)
end

function CW.Landscape.FlipDownUntilNextTurn(playerI, landscapeOwnerI, laneI)
    TurnLandscapeFaceDown(landscapeOwnerI, laneI)

    AtTheStartOfNextTurn(playerI, function ()
        TurnLandscapeFaceUp(landscapeOwnerI, laneI)
    end)
end

CW.Discard = {}

function CW.Discard.ACard(playerI, hint)
    hint = hint or 'Choose a card to discard'
    local cards = STATE.Players[playerI].Hand
    if cards.Count == 0 then
        return nil
    end

    local ids = {}
    for i = 1, cards.Count do
        ids[#ids+1] = i - 1
    end

    local result = ChooseCardInHand(playerI, ids, hint)
    local cardId = STATE.Players[playerI].Hand[result].Original.ID

    DiscardFromHand(playerI, result)

    return cardId
end

function CW.Discard.NCards(playerI, amount, hintFunc)
    hintFunc = hintFunc or function (left)
        return 'Discard a card ('..left..' left)'
    end
    for i = 1, amount do
        CW.Discard.ACard(playerI, hintFunc(amount - i + 1))
        UpdateState()
    end
end

CW.ActivatedAbility = {}

function CW.ActivatedAbility.Add(card, text, cost, effectF, maxActivationsPerTurn)
    maxActivationsPerTurn = maxActivationsPerTurn or -1
    local checkFunc = cost:CheckFunc()
    local costFunc = cost:CostFunc()
    card:AddActivatedAbility({
        maxActivationsPerTurn = maxActivationsPerTurn,
        text = text,
        tags = cost:Tags(),
        checkF = function (me, playerI, laneI)
            return checkFunc(me, playerI, laneI)
        end,
        costF = function (me, playerI, laneI)
            return costFunc(me, playerI, laneI)
        end,
        effectF = function (me, playerI, laneI)
            effectF(me, playerI, laneI, effectF)
        end
    })
end

CW.ActivatedAbility.Cost = {}

function CW.ActivatedAbility.Cost.And(...)
    
    local result = {}
    result.costs = {...}
    assert(#result.costs > 0, 'tried to create activated ability cost with no arguments')

    function result:Tags()
        local tags = {}
        for _, cost in ipairs(self.costs) do
            if cost.Tags ~= nil then
                local costTags = cost:Tags()
                for _, tag in ipairs(costTags) do
                    tags[#tags+1] = tag
                end
            end
        end
        return tags
    end

    function result:CheckFunc()
        return function (me, playerI, laneI)
            return CW.Utility.All(result.costs, function (cost)
                return cost:CheckFunc()(me, playerI, laneI)
            end)
        end
    end

    function result:CostFunc()
        return function (me, playerI, laneI)
            return CW.Utility.All(result.costs, function (cost)
                return cost:CostFunc()(me, playerI, laneI)
            end)
        end
    end

    return result
end

function CW.ActivatedAbility.Cost.Floop()
    local result = {}

    function result:Tags()
        return {'floop'}
    end

    function result:CheckFunc()
        return function (me, playerI, laneI)
            return Common.CanFloop(me)
        end
    end

    function result:CostFunc()
        return function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end
    end

    return result
end

function CW.ActivatedAbility.Cost.Check(checkF)
    local result = {}

    function result:Tags()
        return {'floop'}
    end

    function result:CheckFunc()
        return function (me, playerI, laneI)
            return checkF(me, playerI, laneI)
        end
    end

    function result:CostFunc()
        return function (me, playerI, laneI)
            return true
        end
    end

    return result
end

function CW.ActivatedAbility.Cost.DiscardFromHand(amount, hintFunc, maxActivationsPerTurn)
    maxActivationsPerTurn = maxActivationsPerTurn or -1

    local result = {}

    function result:CheckFunc()
        return function (me, playerI, laneI)
            return GetHandCount(playerI) >= amount
        end
    end

    function result:CostFunc()
        return function (me, playerI, laneI)
            CW.Discard.NCards(playerI, amount, hintFunc)
            return true
        end
    end

    return result
end

CW.Utility = {}

function CW.Utility.All(list, predicate)
    for _, item in ipairs(list) do
        if not predicate(item) then
            return false
        end
    end
    return true
end