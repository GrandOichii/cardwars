-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Destroy target Building in Archer Dan\'s Lane.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.AllPlayers.BuildingsInLane(laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(Common.AllPlayers.BuildingsInLane(laneI))
            local target = TargetBuilding(playerI, ipids, 'Choose a building to destroy')
            DestroyBuilding(target)
        end
    })

    return result
end