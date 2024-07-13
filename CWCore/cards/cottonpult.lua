-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- TODO not specified in the rules, but during testing this leads to an infinite loop
    local targets = function (me, playerI)
        local ipid = me.Original.IPID
        return CW.Targetable.ByBuilding(Common.AllPlayers.CreaturesExcept(ipid), playerI, ipid)
    end

    result:AddActivatedAbility({
        text = 'FLOOP >>> Deal 1 Damage to target Creature. If Cottonpult has 5 or more Damage on it, it heals 1 Damage and readies.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #targets(me, playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(targets(me, playerI))
            local target = TargetCreature(playerI, ipids, 'Choose creature to damage')

            local myIPID = me.Original.IPID
            CW.Damage.ToCreatureByCreatureAbility(myIPID, playerI, target, 1)
            if me.Original.Damage >= 5 then
                HealDamage(myIPID, 1)
                ReadyCard(myIPID)
            end
        end
    })

    return result
end