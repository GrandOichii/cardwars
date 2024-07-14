-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Draw a card for each Building you control.',
        function (me, playerI, laneI)
            local buildings = Common.Buildings(playerI)
            Draw(playerI, #buildings)
        end
    )

    return result
end