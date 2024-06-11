-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Blueberry Pieclops costs 1 less to play for each Spell you have played this turn.
        if layer == CardWars.ModificationLayers.CARD_COST and zone == CardWars.Zones.HAND then
            me.Cost = me.Cost - Common.SpellsPlayedThisTurn(me.Original.OwnerI)
            if me.Cost < 0 then
                me.Cost = 0
            end
        end

    end)

    return result
end