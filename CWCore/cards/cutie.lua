-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> You heal 1 Hit Point (Can't go over 25).

        checkF = function (me, playerI, laneI)
            return not me.Original:IsFlooped()
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            HealHitPoints(playerI, 1)
        end
    })

    return result
end