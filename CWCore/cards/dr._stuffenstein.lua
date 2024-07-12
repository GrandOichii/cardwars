-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Heal 2 Damage from a Creature on an adjacent Landscape. If Dr. Stuffenstein has 5 or more Damage on it, heal 2 Damage from each of your Creatures instead.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.AdjacentCreatures(playerI, laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(Common.Creatures(playerI))
            if me.Original.Damage > 5 then
                local choices = CW.IPIDs(Common.AdjacentCreatures(playerI, laneI))
                local target = ChooseCreature(playerI, choices, 'Choose creature to heal')
                ipids = {target}
            end
            for _, ipid in ipairs(ipids) do
                HealDamage(ipid, 2)
            end
        end
    })

    return result
end