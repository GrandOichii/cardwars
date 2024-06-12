-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- FLOOP >>> You heal 1 Hit Point (Can't go over 25).
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            HealHitPoints(playerI, 1)
        end
    )

    return result
end