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

-- Zones

CardWars.Zones = {
    DISCARD = 'discard',
    IN_PLAY = 'in_play',
    HAND = 'hand',
}

-- Triggers

CardWars.Triggers = {
    TURN_START = 'turn_start',
    CREATURE_ENTER = 'creature_enter'
}

-- Landscapes

CardWars.Landscapes = {
    Rainbow = 'Rainbow',
    BluePlains = 'Blue Plains',
    SandyLands = 'SandyLands',
    Cornfield = 'Cornfield',
    NiceLands = 'NiceLands',
    UselessSwamp = 'UselessSwamp',
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
    DAMAGE_ABSORBTION = 9,
}

-- Card Types

function CardWars:Hero(props)
    local result = {}

    result.StateModifiers = {}
    function result:AddStateModifier(modF)
        result.StateModifiers[#result.StateModifiers+1] = modF
    end

    result.ActivatedEffects = {}
    function result:AddActivatedEffect(effect)
        effect.tags = effect.tags or {}
        effect.text = effect.text or 'MISSING HERO CARD ACTIVATED ABILITY TEXT'
        function effect:HasTag(tag)
            for _, t in ipairs(effect.tags) do
                if t == tag then
                    return true
                end
            end
            return false
        end

        effect.maxActivationsPerTurn = effect.maxActivationsPerTurn or -1
        result.ActivatedEffects[#result.ActivatedEffects+1] = effect
    end

    result.Triggers = {}
    function result:AddTrigger(trigger)
        result.Triggers[#result.Triggers+1] = trigger
    end

    return result
end

function CardWars:Card(props)
    local required = {'name', 'cost', 'type', 'attack', 'defen', 'text'}
    local result = {}

    for _, value in ipairs(required) do
        result[value] = props[value]
    end
    -- result.basePower = result.power
    -- result.baseLife = result.life

    -- result.triggers = {}

    -- -- pipelines

    -- -- CanPlay pipeline
    result.CanPlayP = Core.Pipeline.New()
    result.CanPlayP:AddLayer(
        function (playerI)
            return nil, true
        end
    )
    function result:CanPlay(playerI)
        local _, res = self.CanPlayP:Exec(playerI)
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

    -- function result:IsUnit()
    --     return string.find(result.type, 'Unit') ~= nil
    -- end

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

function CardWars:Spell(props)
    local result = CardWars:Card(props)
    
    result.EffectP = Core.Pipeline:New()
    result.EffectP:AddLayer(
        function(playerI)
            LogInfo('Player ' .. PlayerLogFriendlyName(playerI) .. ' played spell ' .. result.name)
            return nil, true
        end
    )

    function result:Effect(playerI)
        self.EffectP:Exec(playerI)
    end

    return result
end

function CardWars:InPlay(props)
    local result = CardWars:Card(props)

    result.ActivatedEffects = {}
    function result:AddActivatedEffect(effect)
        effect.tags = effect.tags or {}
        effect.text = effect.text or 'MISSING CARD ACTIVATED ABILITY TEXT'
        function effect:HasTag(tag)
            for _, t in ipairs(effect.tags) do
                if t == tag then
                    return true
                end
            end
            return false
        end
        
        effect.maxActivationsPerTurn = effect.maxActivationsPerTurn or -1
        result.ActivatedEffects[#result.ActivatedEffects+1] = effect
    end

    result.Triggers = {}
    function result:AddTrigger(trigger)
        trigger.text = trigger.text or 'MISSING ACTIVATED ABILITY TEXT'
        result.Triggers[#result.Triggers+1] = trigger
    end

    result.OnEnterP = Core.Pipeline:New()

    function result:OnEnter(playerI, laneI, replaced)
        self.OnEnterP:Exec(playerI, laneI, replaced)
    end

    result.OnLeavePlayP = Core.Pipeline:New()
    result.OnLeavePlayP:AddLayer(
        function(playerI, laneI)
            LogInfo('Creature '..result.name .. ' leaves play from lane ' ..laneI)
            return nil, true
        end
    )

    function result:OnLeavePlay(playerI, laneI)
        self.OnLeavePlayP:Exec(playerI, laneI)
    end

    result.OnMoveP = Core.Pipeline:New()
    result.OnMoveP:AddLayer(
        function(playerI, fromI, toI, stolen)
            local s = 'false'
            if stolen then
                s = 'true'
            end
            LogInfo('Creature '..result.name .. ' moves from ' ..fromI..' to '..toI..' (stolen: '..s..')')
            return nil, true
        end
    )

    function result:OnMove(playerI, fromI, toI, stolen)
        self.OnMoveP:Exec(playerI, fromI, toI, stolen)
    end

    return result
end

function CardWars:Creature(props)
    local result = CardWars:InPlay(props)

    result.OnEnterP:AddLayer(
        function(playerI, laneI, replaced)
            LogInfo('Creature '..result.name .. ' with id ' .. STATE.Players[playerI].Landscapes[laneI].Creature.Original.Card.ID .. ' entered play on lane ' ..laneI)
            return nil, true
        end
    )

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
            if lane.Building ~= nil then
                if predicate(lane.Building) then
                    result[#result+1] = lane.Building
                end
            end
        end
    end

    return result
end

function Common.FilterLandscapes(predicate)
    local result = {}

    for pi = 1, STATE.Players.Length do
        local pState = STATE.Players[pi - 1]
        for li = 1, pState.Landscapes.Count do
            local lane = pState.Landscapes[li - 1]
            if predicate(lane) then
                result[#result+1] = lane
            end
        end
    end

    return result
end

function Common.Targetable(byI, tableArr)
    local result = {}

    for _, card in ipairs(tableArr) do
        if card.CanBeTargetedBy:Contains(byI) then
            result[#result+1] = card
        end
    end

    return result
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
        return landscape.Original.OwnerI == playerI and landscape.Building == nil
    end)
end

function Common.LandscapesWithoutCreatures(playerI)
    return Common.FilterLandscapes(function (landscape)
        return landscape.Original.OwnerI == playerI and landscape.Creature == nil
    end)
end

function Common.Creatures(playerI)
    return Common.FilterCreatures(function (creature)
        return creature.Original.ControllerI == playerI
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
            creature.Original.Exhausted
    end)
end

function Common.CreaturesTyped(playerI, landscape)
    return Common.CreaturesTypedExcept(playerI, landscape, '__empty_id__')
end

function Common.LandscapesWithBuildings(playerI)
    return Common.FilterLandscapes(function (landscape)
        return
            landscape.Original.OwnerI == playerI and
            landscape.Building ~= nil
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
    -- TODO
    return landscapes
end

function Common.AvailableToFlipDownLandscapesTyped(landscapeOwnerI, byI, type)
    local landscapes = Common.LandscapesTyped(landscapeOwnerI, type)
    -- TODO
    return landscapes
end

function Common.Lanes(landscapes)
    local result = {}
    for _, landscape in ipairs(landscapes) do
        result[#result+1] = landscape.Original.Idx
    end
    return result
end

function Common.CardsPlayedThisTurnTyped(playerI, type)
    local player = STATE.Players[playerI].Original

    local count = 0
    for i = 1, player.CardsPlayedThisTurn.Count do
        if player.CardsPlayedThisTurn[i - 1].Template.Landscape == type then
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
    local landscapes = Common.LandscapesWithBuildings( playerI)
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

    local result = ChooseCardInHand(playerI, ids, 'Choose a card to discard')
    local cardId = STATE.Players[playerI].Hand[result].Original.ID

    DiscardFromHand(playerI, result)

    return cardId
end

function Common.DiscardNCards(playerI, amount)
    -- TODO could be better
    for i = 1, amount do
        Common.ChooseAndDiscardCard(playerI, 1)
        UpdateState()
    end
end

function Common.ControlBuildingInLane(playerI, laneI)
    return STATE.Players[playerI].Landscapes[laneI].Building ~= nil
end

function Common.TargetOpponent(playerI)
    -- TODO? i don't think teams will be implemented, but just in case, i will leave this here to be edited soon
    return 1 - playerI
end

function Common.CardsInHandWithCostGreaterOrEqual(playerI, cost)
    local result = {}

    -- TODO move to filter function
    local cards = STATE.Players[playerI].Hand
    for i = 1, cards.Count do
        local card = cards[i - 1]
        if card.Cost >= cost then
            result[#result+1] = i - 1
        end
    end

    return result
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
    if lane.Creature ~= nil then
        result[#result+1] = lane.Creature
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
            for _, aa in ipairs(data.ActivatedEffects) do
                if aa:HasTag('floop') then
                    result[#result+1] = aa
                end
            end
        end
    end

    return result
end

Common.AllPlayers = {}

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
        if lane.Building ~= nil then
            local cid = lane.Building.Original.Card.ID
            result[#result+1] = lane.Building
        end
    end

    return result
end

function Common.AllPlayers.LandscapesTyped(type)
    return Common.FilterLandscapes(function (landscape)
        return landscape:Is(type)
    end)
end

function Common.AllPlayers.Creatures()
    return Common.FilterCreatures(function (_) return true end)
end

function Common.AllPlayers.FloopedCreatures()
    return Common.FilterCreatures(function (creature)
        return creature.Original:IsFlooped()
    end)
end

Common.Mod = {}

function Common.Mod.Cost(me, amount)
    me.Cost = me.Cost + amount
    if me.Cost < 0 then
        me.Cost = 0
    end
end

function Common.Mod.ModNextCost(playerI, amount, predicate)
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
                Common.Mod.Cost(card, amount)
            end
        end
    end)
end

Common.Triggers = {}

function Common.Triggers.AtTheStartOfYourTurn(card, effect)
    card:AddTrigger({
        trigger = CardWars.Triggers.TURN_START,
        checkF = function (me, controllerI, laneI, args)
            return args.playerI == controllerI
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = effect
    })
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

Common.ActivatedEffects = {}

function Common.ActivatedEffects.DestroyMe(card, text, effect)
    card:AddActivatedEffect({
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

function Common.ActivatedEffects.Floop(card, text, effect)
    card:AddActivatedEffect({
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

function Common.ActivatedEffects.PayActionPoints(card, amount, text, effect)
    card:AddActivatedEffect({
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

function Common.ActivatedEffects.DiscardCard(card, text, effect, maxActivationsPerTurn)
    maxActivationsPerTurn = maxActivationsPerTurn or -1
    card:AddActivatedEffect({
        text = text,
        maxActivationsPerTurn = maxActivationsPerTurn,
        checkF = function (me, playerI, laneI)
            return GetHandCount(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            Common.ChooseAndDiscardCard(playerI, laneI)
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
    c.CanAttack = false
end

function Common.State.CantBeTargeted(creature, by)
    if by then
        creature.CanBeTargetedBy:Remove(by)
        return
    end
    creature.CanBeTargetedBy:Clear()
end

Common.AbilityGrantingRemoval = {}

function Common.AbilityGrantingRemoval.RemovaAll(card)
    card.ActivatedEffects:Clear()
    card.TriggeredEffects:Clear()
    card.StateModifiers:Clear()
    card.ProcessEnter = false
    card.ProcessLeave = false
    card.ProcessMove = false
end

Common.Flip = {}

function Common.Flip.CanFlipDown(landscape, playerI)
    return landscape.CanFlipDown:Contains(playerI)
end

function Common.Flip.DisallowFlipDownFor(landscape, playerI)
    local allowed = landscape.CanFlipDown
    allowed:Remove(playerI)
end