-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Each Creature you control with a Building on its Landscape had +2 ATK this turn.

            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.CreaturesWithBuildings(playerI)
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + 2
                    end
                end
            end)
        end
    )

    return result
end