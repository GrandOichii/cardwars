-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Draw a card. If Music Mallard has 5 or more Damage on it, draw an additional card.',
        function (me, playerI, laneI)
            Draw(playerI, 1)
            if me.Original.Damage >= 5 then
                Draw(playerI, 1)
            end
        end
    )

    return result
end