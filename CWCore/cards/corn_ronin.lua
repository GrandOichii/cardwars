-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- +1 ATK for each adjacent Cornfield Landscape.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI

            local landscapes = Common.AdjacentLandscapesTyped(ownerI, me.LaneI, CardWars.Landscapes.Cornfield)

            me.Attack = me.Attack + #landscapes
        end

    end)

    return result
end