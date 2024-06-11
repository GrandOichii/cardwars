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
    TurnStart = 'turn_start'
}

-- Landscapes

CardWars.Landscapes = {
    Rainbow = 'rainbow',
    BluePlains = 'Blue Plains',
    SandyLands = 'SandyLands',
    Cornfield = 'Cornfield',
    NiceLands = 'NiceLands',
}

-- Modifiction layers

CardWars.ModificationLayers = {
    ATK_AND_DEF = 1,
    IN_PLAY_CARD_TYPE = 2,
    LANDSCAPE_TYPE = 3,
    CARD_COST = 4,
}

-- Card Types

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
    -- result.CanPlayP = Core.Pipeline.New()
    -- result.CanPlayP:AddLayer(
    --     function (playerID)
    --         return nil, Common.HasEnoughEnergy(result.cost)(playerID)
    --     end
    -- )
    -- function result:CanPlay(playerID)
    --     local _, res = self.CanPlayP:Exec(playerID)
    --     return res
    -- end

    -- -- PayCosts pipeline
    -- result.PayCostsP = Core.Pipeline.New()
    -- result.PayCostsP:AddLayer(
    --     function (playerID)
    --         return nil, Common.PayEnergy(result.cost)(playerID)
    --     end
    -- )
    -- function result:PayCosts(playerID)
    --     local _, res = self.PayCostsP:Exec(playerID)
    --     return res
    -- end

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
        effect.maxActivationsPerTurn = effect.maxActivationsPerTurn or -1
        result.ActivatedEffects[#result.ActivatedEffects+1] = effect
    end

    result.Triggers = {}
    function result:AddTrigger(trigger)
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
        function(playerI, fromI, toI)
            LogInfo('Creature '..result.name .. ' moves from ' ..fromI..' to '..toI)
            return nil, true
        end
    )

    function result:OnMove(playerI, fromI, toI)
        self.OnMoveP:Exec(playerI, fromI, toI)
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

function Common.IDs(stateArr)
    local result = {}
    for _, card in ipairs(stateArr) do
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

function Common.CreaturesInLane(laneI)
    return Common.CreaturesInLaneExcept(laneI, '__empty_id__')
end

function Common.CreaturesNamed(playerI, name)
    return Common.FilterCreatures( function (creature)
        return
            creature.Original.OwnerI == playerI and
            creature.Original.Card.Template.Name == name
    end)
end

function Common.CreaturesInLaneExcept(laneI, id)
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

function Common.CanFloop(card)
    if not GetConfig().CanFloopOnFirstTurn and STATE.TurnCount == 1 then
        return false
    end
    return not card.Original:IsFlooped()
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
    return Common.FilterCreatures(function (building)
        return building.Original.OwnerI == playerI
    end)
end

function Common.Buildings(playerI)
    return Common.FilterBuildings(function (building)
        return building.Original.OwnerI == playerI
    end)
end

function Common.FloopedCreatures(playerI)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.OwnerI == playerI and
            creature.Original:IsFlooped()
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
            creature.Original.OwnerI == playerI and
            creature:IsType(landscape) and
            creature.Original.Card.ID ~= id
    end)
end

function Common.CreaturesThatChangedLanes(playerI)
    return Common.FilterCreatures(function (creature)
        return
            creature.Original.OwnerI == playerI and
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

function Common.LandscapesOfTypeInLane(type, laneI)
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
    DiscardFromHand(playerI, result)

    return result
end

Common.AllPlayers = {}

function Common.AllPlayers.LandscapesTyped(type)
    return Common.FilterLandscapes(function (landscape)
        return landscape:Is(type)
    end)
end

function Common.AllPlayers.Creatures()
    return Common.FilterCreatures(function (_) return true end)
end

Common.Mod = {}

function Common.Mod.Cost(me, amount)
    me.Cost = me.Cost + amount
    if me.Cost < 0 then
        me.Cost = 0
    end
end