-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'Remove a Frozen token from Snow Baller\'s Landscape >>> Deal 3 Damage to target Creature.',
        maxActivationsPerTurn = -1,
        checkF = function (me, playerI, laneI)
            return
                STATE.Players[playerI].Landscapes[laneI]:IsFrozen() and
                #Common.TargetableByCreature(Common.AllPlayers.Creatures(), playerI, me.Original.IPID) > 0
        end,
        costF = function (me, playerI, laneI)
            RemoveToken(playerI, laneI, 'Frozen')
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(Common.TargetableByCreature(Common.AllPlayers.Creatures(), playerI, me.Original.IPID))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to deal 3 Damage to')
            Common.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, target, 3)
        end
    })

    return result
end