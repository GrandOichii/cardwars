-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedEffect({
        text = 'FLOOP >>> Destroy target Building in Archer Dan\'s Lane.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.AllPlayers.BuildingsInLane(laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.AllPlayers.BuildingsInLane(laneI))
            local target = TargetBuilding(playerI, ids, 'Choose a building to destroy')
            DestroyBuilding(target)
        end
    })

    return result
end