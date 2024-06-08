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
    Discard = 'discard'
}

-- Landscapes

CardWars.Landscapes = {
    Rainbow = 'rainbow'
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

    function result:ModifyState(state, me)
        for _, modF in ipairs(result.StateModifiers) do
            modF(state, me)
        end
    end

    return result
end

function CardWars:Creature(props)
    local result = CardWars:InPlay(props)
    
    -- TODO
    -- result.attack = props.attack
    -- result.defense = props.defense

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