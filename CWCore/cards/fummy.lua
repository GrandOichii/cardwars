-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- FLOOP >>> Gain 1 Action this turn.
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            AddActionPoints(playerI, 1)
        end
    )

    return result
end
