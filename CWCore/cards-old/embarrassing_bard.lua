-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Draw a card for each Flooped Creature you control (including this one).',
        function (me, playerI, laneI)
            local creatures = Common.FloopedCreatures(playerI)
            Draw(playerI, #creatures)
        end
    )

    return result
end