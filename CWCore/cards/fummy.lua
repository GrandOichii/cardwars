-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Gain 1 Action this turn.',
        function (me, playerI, laneI)
            AddActionPoints(playerI, 1)
        end
    )

    return result
end