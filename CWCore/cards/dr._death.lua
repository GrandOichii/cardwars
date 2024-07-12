-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'Destroy a Creature you control and FLOOP >>> Destroy target opposing Creature in this Lane.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.TargetableByCreature(Common.OpposingCreaturesInLane(playerI, laneI), playerI, me.Original.IPID) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            local ipids = CW.IPIDs(Common.Creatures(playerI))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to sacrifice to Dr. Death')
            DestroyCreature(target)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(Common.TargetableByCreature(Common.OpposingCreaturesInLane(playerI, laneI), playerI, me.Original.IPID))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to destroy')
            
            DestroyCreature(target)
        end
    })

    return result
end