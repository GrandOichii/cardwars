-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Woadic Matriarch has +1 ATK for each Rainbow Creature you control.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local creatures = Common.CreaturesTyped(me.OwnerI, CardWars.Landscapes.Rainbow)
            me.Attack = me.Attack + #creatures
        end

    end)

    return result
end