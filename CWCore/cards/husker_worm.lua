-- Status: not implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI)
        -- When Husker Worm enters play, flip a Cornfield Landscape you control face down.

        local options = {}
        local lanes = GetPlayer(playerI).Landscapes
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane:Is('Cornfield') then
                options[#options+1] = i - 1
            end
        end

        local lane = ChooseLandscape(playerI, options, {}, 'Choose a Cornfield lane to flip face down')
        TurnLandscapeFaceDown(lane[0], lane[1])
    end)

    result.OnEnterP:AddLayer(function(playerI, laneI)
        -- When  enters play, 
    
        
    end)

    return result
end
