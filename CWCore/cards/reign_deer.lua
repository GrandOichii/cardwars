-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Draw a card for each Landscape with a Frozen token on it players control.',
        function (me, playerI, laneI)
            local landscapes = CW.LandscapeFilter():IsFrozen():Do()
            Draw(playerI, #landscapes)
        end
    )

    return result
end