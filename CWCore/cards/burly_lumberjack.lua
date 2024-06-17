-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- You may play additional Buildings onto this Landscape.

        if layer == CardWars.ModificationLayers.BUILDING_PLAY_LIMIT and zone == CardWars.Zones.IN_PLAY then
            STATE.Players[me.Original.ControllerI].Landscapes[me.LaneI].BuildingPlayLimit = -1
        end

    end)

    return result
end