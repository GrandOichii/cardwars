-- Status: not tested, requires a lot

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Move target Building you control to any Landscape without one.

        checkF = function (me, playerI, laneI)
            if not Common:CanFloop(me) then
                return false
            end
            return
                #Common:LandscapesWithoutBuildings( playerI) > 0 and
                #Common:Buildings( playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local empty = Common:EmptyLandscapes( playerI)
            local ids = Common:IDs(Common:Buildings( playerI))

            local buildingId = ChooseBuilding(playerI, ids, 'Choose a building to move')
            local newLane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            MoveBuilding(buildingId, newLane)
        end
    })

    return result
end