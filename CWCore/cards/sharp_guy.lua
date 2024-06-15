-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        text = 'FLOOP >>> Deal 2 Damage to target opposing Creature in this Lane.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.Targetable(playerI, Common.OpposingCreaturesInLane(playerI, laneI)) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.Targetable(playerI, Common.OpposingCreaturesInLane(playerI, laneI)))
            if #ids == 0 then
                return
            end
            local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
            DealDamageToCreature(target, 2)
        end
    })

    return result
end