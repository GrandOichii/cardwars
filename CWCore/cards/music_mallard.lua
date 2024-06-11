-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Draw a card. If Music Mallard has 5 or more Damage on it, draw an additional card.

        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            Draw(playerI, 1)
            if me.Original.Damage >= 5 then
                Draw(playerI, 1)
            end
        end
    })

    return result
end