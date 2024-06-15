-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Creatures you control each have +2 ATK this turn. Draw 2 cards.

            Draw(playerI, 2)
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.Creatures(playerI)
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + 1
                    end
                end
            end)
        end
    )

    return result
end