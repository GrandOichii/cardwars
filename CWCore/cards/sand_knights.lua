-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- +2 ATK if you control a Blue Plains Landscape.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI

            local landscapes = Common.LandscapesTyped(ownerI, CardWars.Landscapes.BluePlains)
            if #landscapes > 0 then
                me.Attack = me.Attack + 2
            end
        end
    end)

    return result
end