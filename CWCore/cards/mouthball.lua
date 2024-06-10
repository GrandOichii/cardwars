-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- +2 DEF for every 5 cards in your discard pile.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then

            local ownerI = me.Original.OwnerI
            local player = STATE.Players[ownerI]
            local discardCount = player.DiscardPile.Count

            if discardCount == 0 then
                return
            end
            me.Defense = me.Defense + math.floor(discardCount / 5) * 2
        end
    end)

    return result
end