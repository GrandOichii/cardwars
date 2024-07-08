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
                #Common.TargetableByCreature(Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.Card.ID), playerI, me.Original.Card.ID) > 0
        end,
        costF = function (me, playerI, laneI)
            Common.ChooseAndDiscardCard(me.Original.ControllerI)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = CW.IDs(Common.TargetableBySpell(Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.Card.ID), playerI, me.Original.Card.ID))
            local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
            Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, target, 1)
        end
    })

    return result
end