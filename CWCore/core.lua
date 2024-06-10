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
    Discard = 'discard',
    InPlay = 'in_play'
}

-- Triggers

CardWars.Triggers = {
    TurnStart = 'turn_start'
}

-- Landscapes

CardWars.Landscapes = {
    Rainbow = 'rainbow'
}

-- Modifiction layers

CardWars.ModificationLayers = {
    ATK_AND_DEF = 1,
    IN_PLAY_CARD_TYPE = 2,
    LANDSCAPE_TYPE = 3,
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
    --         return nil, Common:HasEnoughEnergy(result.cost)(playerID)
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
    --         return nil, Common:PayEnergy(result.cost)(playerID)
    --     end
    -- )
    -- function result:PayCosts(playerID)
    --     local _, res = self.PayCostsP:Exec(playerID)
    --     return res
    -- end

    -- function result:IsUnit()
    --     return string.find(result.type, 'Unit') ~= nil
    -- end

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

    result.StateModifiers = {}

    function result:AddStateModifier(modF)
        result.StateModifiers[#result.StateModifiers+1] = modF
    end

    function result:ModifyState(state, me, layer)
        for _, modF in ipairs(result.StateModifiers) do
            modF(state, me, layer)
        end
    end

    result.ActivatedEffects = {}
    function result:AddActivatedEffect(effect)
        result.ActivatedEffects[#result.ActivatedEffects+1] = effect
    end

    result.Triggers = {}
    function result:AddTrigger(trigger)
        result.Triggers[#result.Triggers+1] = trigger
    end

    result.OnEnterP = Core.Pipeline:New()
    result.OnEnterP:AddLayer(
        function(playerI, laneI, replaced)
            LogInfo('Creature '..result.name .. ' entered play on lane ' ..laneI)
            return nil, true
        end
    )

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

    return result
end

-- Common

Common = {}

Common.State = {}

function Common.State:FilterCreatures(state, predicate)
    local result = {}

    for pi = 1, state.Players.Length do
        local pState = state.Players[pi - 1]
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

function Common.State:FilterBuildings(state, predicate)
    local result = {}

    for pi = 1, state.Players.Length do
        local pState = state.Players[pi - 1]
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

function Common.State:FilterLandscapes(state, predicate)
    local result = {}

    for pi = 1, state.Players.Length do
        local pState = state.Players[pi - 1]
        for li = 1, pState.Landscapes.Count do
            local lane = pState.Landscapes[li - 1]
            if predicate(lane) then
                result[#result+1] = lane
            end
        end
    end

    return result
end

function Common.State:AdjacentLandscapes(state, playerI, laneI)
    local result = {}

    local lanes = state.Players[playerI].Landscapes
    if laneI - 1 >= 0 then
        result[#result+1] = lanes[laneI - 1]
    end
    if laneI + 1 < lanes.Count then
        result[#result+1] = lanes[laneI + 1]
    end

    return result
end

function Common.State:CreatureIDs(state, predicate)
    local creatures = Common.State:FilterCreatures(state, predicate)
    local result = {}
    for _, creature in ipairs(creatures) do
        result[#result+1] = creature.Original.Card.ID
    end
    return result
end

function Common.State:BuildingIDs(state, predicate)
    local buildings = Common.State:FilterBuildings(state, predicate)
    local result = {}
    for _, building in ipairs(buildings) do
        result[#result+1] = building.Original.Card.ID
    end
    return result
end


function Common.State:LandscapeLanes(state, playerI, predicate)
    local landscapes = Common.State:FilterLandscapes(state, predicate)
    local result = {}
    for _, landscape in ipairs(landscapes) do
        if landscape.Original.OwnerI == playerI then
            result[#result+1] = landscape.Original.Idx
        end
    end
    return result
end

function Common.State:CanFloop(state, card)
    if not GetConfig().CanFloopOnFirstTurn and state.TurnCount == 1 then
        return false
    end
    return not card.Original:IsFlooped()
end