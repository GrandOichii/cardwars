-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- While Angel Heart has exactly 3 Damage on it, it has +3 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            if me.Original.Damage == 3 then
                me.Attack = me.Attack + 3
            end

        end
    end)

    return result
end