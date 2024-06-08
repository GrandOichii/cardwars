-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnLeavePlayP:AddLayer(function(playerI, laneI)
        -- When Ethan Allfire leaves play, draw 1 card for each Cornfield Landscape you control.

        local count = 0
        local lanes = GetLanes(playerI)
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane:Is('Cornfield') then
                count = count + 1
            end
        end

        Draw(playerI, count)
    end)

    return result
end
