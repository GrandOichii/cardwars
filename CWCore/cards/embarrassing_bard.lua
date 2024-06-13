-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Draw a card for each Flooped Creature you control (including this one).',
        function (me, playerI, laneI)
            local creatures = Common.FloopedCreatures(playerI)
            Draw(playerI, #creatures)
        end
    )

    return result
end