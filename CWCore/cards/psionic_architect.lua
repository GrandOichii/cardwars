-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI)
        -- When Psionic Architect enters play, you may ready a Flooped Creature you control.

        local state = GetState()
        local ids = Common.State:CreatureIDs(state, function (creature)
            return
                creature.Original.OwnerI == playerI and
                creature.Original:IsFlooped()
        end)

        if #ids == 0 then
            return
        end

        local creatureId = ChooseCreature(playerI, ids, 'Choose a creature to ready')
        local creature = GetCreatureOrDefault(creatureId)

        if creature == nil then
            -- * shouldn't ever happen
            error('GetCreatureOrDefault returned nil, when it shouldn\'t')
        end

        local accept = YesNo(playerI, 'Ready '..creature.Original.Card.Template.Name..'?')
        if not accept then
            return
        end

        ReadyCard(creatureId)
    end)

    return result
end
