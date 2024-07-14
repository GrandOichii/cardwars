-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.DiscardCard(result,
        'Discard a card >>> Dogboy has +2 ATK this turn. (Use only once during each of your turns.)',
        function (me, playerI, laneI)
            local id = me.Original.Card.ID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(id)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 2
                end
            end)
        end, 1
    )

    return result
end