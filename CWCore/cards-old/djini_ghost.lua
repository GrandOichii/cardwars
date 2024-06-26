-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Pay 2 less to play your next Spell this Turn.',
        function (me, playerI, laneI)
            Common.Mod.ModNextCost(playerI, -2, function (card)
                return card.Original.Template.Type == 'Spell'
            end)
        end
    )

    return result
end