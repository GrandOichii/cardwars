-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Husker Worm enters play, flip a Cornfield Landscape you control face down.

        local options = Common.Lanes(Common.AvailableToFlipDownLandscapesTyped(playerI, playerI, CardWars.Landscapes.Cornfield))
        if #options == 0 then
            return
        end

        local lane = ChooseLandscape(playerI, options, {}, 'Choose a Cornfield lane to flip face down')
        TurnLandscapeFaceDown(lane[0], lane[1])
    end)

    return result
end
