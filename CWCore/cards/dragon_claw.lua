-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

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

    result:AddActivatedEffect({
        -- FLOOP >>> Move a Creature you control to an empty Lane.

        checkF = function (me, playerI, laneI)
            if not Common.State:CanFloop(GetState(), me) then
                return false
            end
            return #getLaneOptions(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
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
    })

    return result
end