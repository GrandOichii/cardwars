-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- TODO? doesn't specify that it TARGETS
    result:AddActivatedEffect({
        -- Discard a card >>> Deal 1 Damage to another Creature in this Lane. (Use any number of times during each of your turns.)

        maxActivationsPerTurn = -1,
        checkF = function (me, playerI, laneI)
            return
                STATE.Players[me.Original.ControllerI].Hand.Count > 0 and
                #Common.Targetable(playerI, Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.Card.ID)) > 0
        end,
        costF = function (me, playerI, laneI)
            Common.ChooseAndDiscardCard(me.Original.ControllerI)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.Targetable(playerI, Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.Card.ID)))
            local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
            DealDamageToCreature(target, 1)
        end
    })

    return result
end