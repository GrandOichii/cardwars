-- Status: partially implemented

function _Create(props)
    local result = CardWars:Spell(props)

    -- TODO add check function - check that a creature exists and can be moved

    -- TODO repeated code
    local getLaneOptions = function (playerI)
        local options = {}
        local lanes = GetLanes(playerI)
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane.Creature == nil then
                options[#options+1] = lane.Original.Idx
            end
        end
        return options
    end

    result.EffectP:AddLayer(
        function (playerI)
            -- Move one of your Creatures to one of your empty Lanes.

            -- TODO repeated code
            local creatures = GetCreatures(playerI)
            local creatureOptions = {}
            for _, creature in ipairs(creatures) do
                creatureOptions[#creatureOptions+1] = creature.Original.Card.ID
            end

            local creatureId = ChooseCreature(playerI, creatureOptions, 'Choose a creature to move')

            local options = getLaneOptions(playerI)
            local lane = ChooseLane(playerI, options, 'Choose an empty Lane to move to')

            MoveCreature(creatureId, lane)

        end
    )

    return result
end