-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- While Albino Eyebat has exactly 2 Damage on it, it has +2 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            if me.Original.Damage == 2 then
                me.Attack = me.Attack + 2
            end
        end
    end)

    return result
end