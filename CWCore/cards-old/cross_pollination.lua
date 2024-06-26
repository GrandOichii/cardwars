-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Each of your Cornfield Creatures has +1 ATK this turn for each different Landscape type you control.

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then

                    local creatures = Common.CreaturesTyped(playerI, CardWars.Landscapes.Cornfield)
                    
                    local amount = #GetUniqueLandscapeNames(playerI)
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + amount
                    end

                end
            end)

        end
    )

    return result
end