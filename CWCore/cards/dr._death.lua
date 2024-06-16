-- Destroy a Creature you control and FLOOP >>> Destroy target opposing Creature in this Lane.

-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = '',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.Targetable(playerI, Common.OpposingCreaturesInLane(playerI, laneI)) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            local ids = Common.IDs(Common.Creatures(playerI))
            local target = TargetCreature(playerI, ids, 'Choose a creature to sacrifice to Dr. Death')
            DestroyCreature(target)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.Targetable(playerI, Common.OpposingCreaturesInLane(playerI, laneI)))
            local target = TargetCreature(playerI, ids, 'Choose a creature to destroy')
            
            DestroyCreature(target)
        end
    })

    return result
end