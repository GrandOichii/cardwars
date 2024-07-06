-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result.OnLeavePlayP:AddLayer(function(playerI, laneI)
        -- When Ethan Allfire leaves play, draw 1 card for each Cornfield Landscape you control.

        local count = Common.CountLandscapesTyped(playerI, CardWars.Landscapes.Cornfield)

        Draw(playerI, count)
    end)

    return result
end
