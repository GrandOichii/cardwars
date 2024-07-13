-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Reduce the cost of the next Creature you play this turn by 2 Actions.

            CW.Mod.ModNextCost(playerI, -2,
                function (card)
                    return card.Original.Template.Type == 'Creature'
                end
            )
        end
    )

    return result
end