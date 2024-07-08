-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    local filter = function (myId, playerI)
        return Common.TargetableByCreature(Common.CreaturesExcept(playerI, myId), playerI, myId)
    end

    result:AddActivatedAbility({
        text = 'Pay 1 Action >>> Move all Damage on this Creature to target Creature.',
        checkF = function (me, playerI, laneI)
            return
                GetPlayer(playerI).Original.ActionPoints >= 1 and
                #filter(me.Original.Card.ID, playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, 1)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = CW.IDs(filter(me.Original.Card.ID, playerI))
            local target = TargetCreature(playerI, ids, 'Choose a creature to move '..me.Original.Damage..' damage to')
            local creature = GetCreature(target)
            local damage = me.Original.Damage
            me.Original.Damage = 0
            creature.Original.Damage = damage
        end
    })

    return result
end