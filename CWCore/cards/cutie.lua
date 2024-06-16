-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> You heal 1 Hit Point (Can\'t go over 25).',
        function (me, playerI, laneI)
            HealHitPoints(playerI, 1)
        end
    )

    return result
end