-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'Remove a Frozen token from Snow Baller\'s Landscape >>> Deal 3 Damage to target Creature.',
        maxActivationsPerTurn = -1,
        checkF = function (me, playerI, laneI)
            return
                STATE.Players[playerI].Landscapes[laneI]:IsFrozen() and
                #Common.TargetableByCreature(Common.AllPlayers.Creatures(), playerI, me.Original.Card.ID) > 0
        end,
        costF = function (me, playerI, laneI)
            RemoveToken(playerI, laneI, 'Frozen')
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = CW.IDs(Common.TargetableByCreature(Common.AllPlayers.Creatures(), playerI, me.Original.Card.ID))
            local target = TargetCreature(playerI, ids, 'Choose a creature to deal 3 Damage to')
            Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, target, 3)
        end
    })

    return result
end