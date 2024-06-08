-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Gain 1 Action this turn.

        checkF = function (me, playerI, laneI)
            return not me.Original:IsFlooped()
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            AddActionPoints(playerI, 1)
        end
    })

    return result
end