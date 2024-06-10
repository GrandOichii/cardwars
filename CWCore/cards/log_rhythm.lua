-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Each Creature you control with a Building on its Landscape had +2 ATK this turn.

            UntilEndOfTurn(function (state, layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local landscapes = Common.State:LandscapesWithBuildings(state, playerI)
                    for _, landscape in ipairs(landscapes) do
                        local creature = landscape.Creature
                        if creature ~= nil then
                            creature.Attack = creature.Attack + 2
                        end
                    end
                end
            end)
        end
    )

    return result
end