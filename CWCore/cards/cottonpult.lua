-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Deal 1 Damage to target Creature. If Cottonpult has 5 or more Damage on it, it heals 1 Damage and readies.

        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.FilterCreatures(function (creature) return true end))
            local target = TargetCreature(playerI, ids, 'Choose creature to damage')
            if me.Original.Damage >= 5 then
                local id = me.Original.Card.ID
                HealDamage(id, 1)
                ReadyCard(id)
            end
        end
    })

    return result
end