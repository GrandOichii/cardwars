-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    -- Each Creature that changed Lanes this turn has +2 ATK this turn.
    result.EffectP:AddLayer(
        function (playerI)

            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.FilterCreatures( function (creature)
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