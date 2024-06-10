-- Status: not tested, requires a lot

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Move target Building you control to any Landscape without one.

        checkF = function (me, playerI, laneI)
            if not Common.State:CanFloop(GetState(), me) then
                return false
            end
            local state = GetState()
            return
                #Common.State:EmptyLandscapes(state, playerI) > 0 and
                #Common.State:Buildings(state, playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local state = GetState()
            local empty = Common.State:EmptyLandscapes(state, playerI)
            local ids = Common:IDs(Common.State:Buildings(state, playerI))

            local buildingId = ChooseBuilding(playerI, ids, 'Choose a building to move')
            local newLane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            MoveBuilding(buildingId, newLane)
        end
    })

    return result
end