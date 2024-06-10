-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- Pay 1 Action >>> Heal all Damage from Angel of Chocolate.
        
        checkF = function (me, playerI, laneI)
            return GetPlayer(playerI).Original.ActionPoints >= 1
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, -1)
            return true
        end,
        effectF = function (me, playerI, laneI)
            HealDamage(me.Original.Card.ID, me.Original.Damage)
        end
    })

    return result
end