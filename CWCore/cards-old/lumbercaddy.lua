-- Status: not tested, requires a lot

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        text = 'FLOOP >>> Move target Building you control to any Landscape without one.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.LandscapesWithoutBuildings(playerI) > 0 and
                #Common.Buildings(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local empty = Common.Lanes(Common.LandscapesWithoutBuildings(playerI))
            local ids = Common.IDs(Common.Buildings(playerI))

            local buildingId = ChooseBuilding(playerI, ids, 'Choose a building to move')
            local newLane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            MoveBuilding(buildingId, newLane)
        end
    })

    return result
end