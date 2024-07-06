-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Each of your Creatures with no Damage has +2 ATK this turn.

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.CreaturesWithNoDamage(playerI)
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + 2
                    end
                end
            end)
        end
    )

    return result
end