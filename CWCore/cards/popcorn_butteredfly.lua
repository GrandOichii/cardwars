-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Draw a card for each Building you control.',
        function (me, playerI, laneI)
            local buildings = Common.Buildings(playerI)
            Draw(playerI, #buildings)
        end
    )

    return result
end