-- Status: not tested
-- TODO copied code from Dragon Foot

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.DiscardCard(result, function (me, playerI, laneI)
        local id = me.Original.Card.ID
        UntilEndOfTurn(function (layer)
            if layer == CardWars.ModificationLayers.ATK_AND_DEF  then
                local creature = GetCreatureOrDefault(id)
                if creature == nil then
                    return
                end
                creature.Attack = creature.Attack + 4
            end
        end)
    end, 1)

    return result
end