-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(result,
        'FLOOP >>> Pay 2 less to play your next Spell this Turn.',
        function (me, playerI, laneI)
            CW.Mod.ModNextCost(playerI, -2, function (card)
                return card.Original.Template.Type == 'Spell'
            end)
        end
    )

    return result
end