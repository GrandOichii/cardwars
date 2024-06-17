-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- Frosted Deanimator may enter play onto a Landscape that has a Frozen token on it.

        if layer == CardWars.ModificationLayers.LANE_PLAY_RESTRICTIONS and zone == CardWars.Zones.HAND then
            local landscapes = STATE.Players[me.Original.OwnerI].Landscapes
            for i = 0, landscapes.Count - 1 do
                me.LanePlayRestrictions[i]:Remove('IsFrozen')
            end
        end

    end)

    return result
end