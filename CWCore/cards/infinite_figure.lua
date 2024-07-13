-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- TODO? doesn't specify that it TARGETS
    result:AddActivatedAbility({
        text = 'Discard a card >>> Deal 1 Damage to another Creature in this Lane. (Use any number of times during each of your turns.)',

        maxActivationsPerTurn = -1,
        checkF = function (me, playerI, laneI)
            return
                STATE.Players[me.Original.ControllerI].Hand.Count > 0 and
                #CW.Targetable.ByCreature(Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.IPID), playerI, me.Original.IPID) > 0
        end,
        costF = function (me, playerI, laneI)
            Common.ChooseAndDiscardCard(me.Original.ControllerI)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(CW.Targetable.BySpell(Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.IPID), playerI, me.Original.IPID))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to deal damage to')
            CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, target, 1)
        end
    })

    return result
end