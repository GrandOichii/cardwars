-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- If you have 10 or more cards in your discard pile, pay 2 fewer Actions to play Teeth Leaf.

        if layer == CardWars.ModificationLayers.CARD_COST and zone == CardWars.Zones.HAND then
            local ownerI = me.Original.OwnerI
            local player = STATE.Players[ownerI]
            local discardCount = player.DiscardPile.Count
            if discardCount > 3 then
                Common.Mod.Cost(me, -2)
            end
        end

    end)

    return result
end