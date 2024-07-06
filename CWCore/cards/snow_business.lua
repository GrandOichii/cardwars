-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    Common.ActivatedAbilities.PayActionPoints(result, 1,
        'Pay 1 Action >>> Freeze target Landscape in this Lane.',
        function (me, playerI, laneI)
            -- TODO? change to TargetLandscape
            local lane = ChooseLandscape(playerI, {laneI}, {laneI}, 'Choose a Landscape to freeze')
            Common.FreezeLandscape(lane[0], lane[1])
        end
    )

    return result
end