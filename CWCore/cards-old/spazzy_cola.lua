-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Each Creature in play has +1 ATK this turn (including your opponent's Creatures).

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.AllPlayers.Creatures()
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + 1
                    end
                end
            end)
        end
    )

    return result
end