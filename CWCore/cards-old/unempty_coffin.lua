-- Reduce the cost of the next Creature you play this turn by 2 Actions.
-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- 
            
            Common.Mod.ModNextCost(playerI, -2,
                function (card)
                    return card.Original.Template.Type == 'Creature'
                end
            )
        end
    )

    return result
end