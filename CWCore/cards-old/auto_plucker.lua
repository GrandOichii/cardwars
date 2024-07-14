-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- FLOOP >>> Heal or deal 1 Damage to your Creature in this Lane.
    result:AddActivatedAbility({
        text = 'FLOOP >>> Heal or deal 1 Damage to your Creature in this Lane.',
        tags = {'floop'},


        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.CreaturesInLane(playerI, laneI) == 1
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local id = CW.IDs(Common.CreaturesInLane(playerI, laneI))[1]
            local creature = GetCreature(id)
            local accept = YesNo(playerI, 'Heal 1 damage from '..creature.Original.Card.Template.Name..'?')
            if accept then
                HealDamage(id, 1)
                return
            end
            DealDamageToCreature(id, 1)
        end
    })

    return result
end