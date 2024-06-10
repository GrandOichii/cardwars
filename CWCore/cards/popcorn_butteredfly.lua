-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Draw a card for each Building you control.

        checkF = function (me, playerI, laneI)
            return Common.State:CanFloop(GetState(), me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local buildings = Common.State:Buildings(GetState(), playerI)
            Draw(playerI, #buildings)
        end
    })

    return result
end