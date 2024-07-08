-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Husker Worm enters play, flip a Cornfield Landscape you control face down.

        local options = CW.Lanes(Common.AvailableToFlipDownLandscapesTyped(playerI, playerI, CardWars.Landscapes.Cornfield))
        if #options == 0 then
            return
        end

        local lane = ChooseLandscape(playerI, options, {}, 'Choose a Cornfield lane to flip face down')
        TurnLandscapeFaceDown(lane[0], lane[1])
    end)

    return result
end
