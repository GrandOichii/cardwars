-- Lost Golem costs 1 less to play for each other Creature you have played this turn.

-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- 
    
        if layer == CardWars.ModificationLayers.CARD_COST and zone == CardWars.Zones.HAND then
            local ownerI = me.Original.OwnerI
            local count = Common.SpellsPlayedThisTurnCount(ownerI)
            Common.Mod.Cost(me, -count)
        end
    
    end)

    return result
end