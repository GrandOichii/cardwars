-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    Common.ActivatedEffects.Floop(result,
        'Pay 2 Actions >>> Steal a random card from your opponent and play it at no cost.',
        function (me, playerI, laneI)
            
        end
    )

    return result
end