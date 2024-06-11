-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Draw a card for each Flooped Creature you control (including this one).

        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ownerI = me.Original.OwnerI
            local creatures = Common.FloopedCreatures(playerI)
            Draw(playerI, #creatures)
        end
    })

    return result
end