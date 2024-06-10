-- Status: Implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Each Creature that changed Lanes this turn has +2 ATK this turn.

            UntilEndOfTurn(function (state, layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.State:FilterCreatures(state, function (creature)
                        return
                            creature.Original.MovementCount > 0
                    end)

                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + 2
                    end
                end
            end)
        end
    )

    return result
end