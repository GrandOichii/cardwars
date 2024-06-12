-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- Pay 1 Action >>> Freeze a Landscape in this Lane.
    Common.ActivatedEffects.PayActionPoints(result, 1,
        function (me, playerI, laneI)
            local lane = ChooseLandscape(playerI, {laneI}, {laneI}, 'Choose a Landscape to freeze')
            TurnLandscapeFaceUp(lane[0], lane[1])
            Common.FreezeLandscape(lane[0], lane[1])
        end
    )

    return result
end