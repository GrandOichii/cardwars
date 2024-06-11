-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    result:AddActivatedEffect({
        -- FLOOP >>> Heal 1 Damage from Corns Templar.
    
        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            HealDamage(STATE.Players[playerI].Landscapes[laneI].Creature.Original.Card.ID, 1)
        end
    })

    return result
end