-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- FLOOP >>> Draw a card for each Building you control.
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            local buildings = Common.Buildings(playerI)
            Draw(playerI, #buildings)
        end
    )

    return result
end