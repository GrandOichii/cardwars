-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Gain 1 Action this turn.',
        function (me, playerI, laneI)
            AddActionPoints(playerI, 1)
        end
    )

    return result
end
