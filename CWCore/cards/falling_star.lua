-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Creatures you control take no Damage from opposing Creatures this turn.

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.DAMAGE_MODIFICATION then
                    local creatures = Common.Creatures(playerI)
                    for _, creature in ipairs(creatures) do
                        Common.Damage.PreventCreatureDamage(creature)
                    end
                end
            end)
        end
    )

    return result
end