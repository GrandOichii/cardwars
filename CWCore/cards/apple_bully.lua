-- Status: implemented, requires a lot of testing

function _Create()
    local result = CardWars:Creature()
    result:AddStateModifier(function (me, layer, zone)
        -- Apple Bully's Landscape cannot be flipped down by effects opponents control.

        if layer == CardWars.ModificationLayers.LANDSCAPE_FLIP_DOWN_AVAILABILITY and zone == CardWars.Zones.IN_PLAY then
            local landscape = CW.LandscapeOf(me)
            local controllerI = me.Original.ControllerI
            local idxs = CW.PlayerFilter():OpponentsOf(controllerI):Do()
            for _, idx in ipairs(idxs) do
                CW.Flip.DisallowFlipDownFor(landscape.Original.OwnerI, landscape.Original.Idx, idx)
            end
        end
    end)

    return result
end