-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnLeavePlayP:AddLayer(function(playerI, laneI)
        -- When Ethan Allfire leaves play, draw 1 card for each Cornfield Landscape you control.

        local count = #Common.LandscapesTyped(playerI, CardWars.Landscapes.Cornfield)

        Draw(playerI, count)
    end)

    return result
end
