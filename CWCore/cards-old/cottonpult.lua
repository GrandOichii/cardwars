-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        text = 'FLOOP >>> Deal 1 Damage to target Creature. If Cottonpult has 5 or more Damage on it, it heals 1 Damage and readies.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.Targetable(playerI, Common.AllPlayers.Creatures()) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.Targetable(playerI, Common.AllPlayers.Creatures()))
            local target = TargetCreature(playerI, ids, 'Choose creature to damage')
            DealDamageToCreature(target, 1)
            if me.Original.Damage >= 5 then
                local id = me.Original.Card.ID
                HealDamage(id, 1)
                ReadyCard(id)
            end
        end
    })

    return result
end