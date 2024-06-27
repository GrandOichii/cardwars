-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:InPlay()

    result:AddStateModifier(function (me, layer, zone)
        -- Learning Center gains the game text of Buildings you control in adjacent Lanes (but not their names).

        if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL and zone == CardWars.Zones.IN_PLAY then
            local buildings = Common.AdjacentBuildings(me.Original.ControllerI, me.LaneI)
            -- !FIXME this modifies the list while iterating, so it crashes
            for _, building in ipairs(buildings) do
                Common.AbilityGrantingRemoval.CopyFromBuilding(me, building)
            end
        end

    end)

    return result
end