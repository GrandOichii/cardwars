-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- While Papercut Tiger has exactly 5 Damage on it, it has +5 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            if me.Original.Damage == 5 then
                me.Attack = me.Attack + 5
            end
        end
    
    end)

    return result
end