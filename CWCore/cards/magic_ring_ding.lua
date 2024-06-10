-- Status: implemented, not tested

function _Create(props)
    local result = CardWars:Spell(props)
    
    result.EffectP:AddLayer(
        function (playerI)
            -- Each of your Creatures has +1 ATK this turn for every 5 cards in your discard pile.

            UntilEndOfTurn(function (state, layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.State:FilterCreatures(state, function (creature)
                        return creature.Original.OwnerI == playerI
                    end)

                    local amount = state.Players[playerI].DiscardPile.Count
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + math.floor(amount / 5)
                    end
                end
            end)
        end
    )

    return result
end