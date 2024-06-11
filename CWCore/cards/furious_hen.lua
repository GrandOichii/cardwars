-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    result:AddStateModifier(function (me, layer, zone)
        -- Furious Hen has +1 ATK for each Damage on it.
    
        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            me.Attack = me.Attack + me.Original.Damage
        end
    
    end)

    return result
end