-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> You heal 1 Hit Point (Can\'t go over 25).',
        function (me, playerI, laneI)
            HealHitPoints(playerI, 1)
        end
    )

    return result
end