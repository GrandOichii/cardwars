-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.PayActionPoints(result, 1,
        'Pay 1 Action >>> Freeze a Landscape in this Lane.',
        function (me, playerI, laneI)
            local lane = ChooseLandscape(playerI, {laneI}, {laneI}, 'Choose a Landscape to freeze')
            Common.FreezeLandscape(lane[0], lane[1])
        end
    )

    return result
end