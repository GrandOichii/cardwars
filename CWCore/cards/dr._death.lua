-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'Destroy a Creature you control and FLOOP >>> Destroy target opposing Creature in this Lane.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.TargetableByCreature(Common.OpposingCreaturesInLane(playerI, laneI), playerI, me.Original.Card.ID) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            local ids = Common.IDs(Common.Creatures(playerI))
            local target = TargetCreature(playerI, ids, 'Choose a creature to sacrifice to Dr. Death')
            DestroyCreature(target)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.TargetableByCreature(Common.OpposingCreaturesInLane(playerI, laneI), playerI, me.Original.Card.ID))
            local target = TargetCreature(playerI, ids, 'Choose a creature to destroy')
            
            DestroyCreature(target)
        end
    })

    return result
end