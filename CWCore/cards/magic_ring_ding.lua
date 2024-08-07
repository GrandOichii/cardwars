-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Each of your Creatures has +1 ATK this turn for every 5 cards in your discard pile.

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local count = STATE.Players[playerI].DiscardPile.Count
                    if count == 0 then
                        return
                    end
                    local amount = math.floor(count / 5)
                    local creatures = CW.CreatureFilter()
                        :ControlledBy(playerI)
                        :Do()
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + amount
                    end
                end
            end)
        end
    )

    return result
end