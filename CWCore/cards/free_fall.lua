-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Each of your Creatures has +1 ATK this turn for each Creature that entered play this turn.

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = CW.CreatureFilter():ControlledBy(playerI):Do()
                    local amount = #CW.CreaturesThatEnteredPlayThisTurn()
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + amount
                    end
                end
            end)
        end
    )

    return result
end