-- Status: not implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Husker Worm enters play, flip a Cornfield Landscape you control face down.

        local options = {}
        local lanes = GetPlayer(playerI).Landscapes
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane:Is('Cornfield') then
                options[#options+1] = i - 1
            end
        end
        if #options == 0 then
            return
        end

        local lane = ChooseLandscape(playerI, options, {}, 'Choose a Cornfield lane to flip face down')
        TurnLandscapeFaceDown(lane[0], lane[1])
    end)

    return result
end
