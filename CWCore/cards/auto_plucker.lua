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
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipid = CW.IPIDs(Common.CreaturesInLane(playerI, laneI))[1]
            local creature = GetCreature(ipid)
            local accept = YesNo(playerI, 'Heal 1 damage from '..creature.Original.Card.Template.Name..'?')
            if accept then
                HealDamage(ipid, 1)
                return
            end
            CW.Damage.ToCreatureByBuildingAbility(me.Original.IPID, playerI, ipid, 1)
        end
    })

    return result
end