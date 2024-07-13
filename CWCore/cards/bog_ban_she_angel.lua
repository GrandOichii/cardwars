-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    local filter = function (myIPID, playerI)
        -- !FIXME card text doesn't exclude itself
        return CW.Targetable.ByCreature(Common.CreaturesExcept(playerI, myIPID), playerI, myIPID)
    end

    result:AddActivatedAbility({
        text = 'Pay 1 Action >>> Move all Damage on this Creature to target Creature.',
        checkF = function (me, playerI, laneI)
            return
                GetPlayer(playerI).Original.ActionPoints >= 1 and
                #filter(me.Original.IPID, playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, 1)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(filter(me.Original.IPID, playerI))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to move '..me.Original.Damage..' damage to')
            local creature = GetCreature(target)
            local damage = me.Original.Damage
            me.Original.Damage = 0
            creature.Original.Damage = damage
        end
    })

    return result
end