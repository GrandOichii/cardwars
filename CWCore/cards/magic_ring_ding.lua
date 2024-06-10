-- Status: implemented, not tested

function _Create(props)
    local result = CardWars:Spell(props)
    
    result.EffectP:AddLayer(
        function (playerI)
            -- Each of your Creatures has +1 ATK this turn for every 5 cards in your discard pile.

            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common:FilterCreatures( function (creature)
                        return creature.Original.OwnerI == playerI
                    end)

                    local amount = STATE.Players[playerI].DiscardPile.Count
                    if amount == 0 then
                        return
                    end
                    for _, creature in ipairs(creatures) do
            
                        creature.Attack = creature.Attack + math.floor(amount / 5)
                    end
                end
            end)
        end
    )

    return result
end