-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Deal 2 Damage to target opposing Creature in this Lane.

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.CreaturesInLaneExcept(laneI, me.Original.Card.ID) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.CreaturesInLaneExcept(laneI, me.Original.Card.ID))
            local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
            DealDamageToCreature(target, 2)
        end
    })

    return result
end