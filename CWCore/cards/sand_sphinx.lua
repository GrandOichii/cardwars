-- Status: implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    local getCreature = function (playerI, laneI)
        local state = GetState()
        local player = state.Players[playerI]
        local landscape = player.Landscapes[laneI]
        return landscape.Creature
    end

    result:AddActivatedEffect({
        -- FLOOP >>> Return a Creature you control in this Lane to its owner's hand.

        checkF = function (me, playerI, laneI)
            return Common.State:CanFloop(GetState(), me) and getCreature(playerI, laneI) ~= nil
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local creature = getCreature(playerI, laneI)
            ReturnCreatureToOwnersHand(creature.Original.Card.ID)
        end
    })

    return result
end