-- FLOOP >>> Deal 2 Damage to target opposing Creature in this Lane.

-- Status: not implemented - target opposing creature?

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> .
    
        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            
        end
    })

    return result
end