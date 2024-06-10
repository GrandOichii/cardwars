-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Draw a card for each Building you control.

        checkF = function (me, playerI, laneI)
            return Common:CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local buildings = Common:Buildings(playerI)
            Draw(playerI, #buildings)
        end
    })

    return result
end