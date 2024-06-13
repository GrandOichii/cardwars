-- Status: implemented, requires a lot of testing

function _Create(props)
    local result = CardWars:Creature(props)
    result:AddStateModifier(function (me, layer, zone)
        -- Apple Bully's Landscape cannot be flipped down by effects opponents control.

        if layer == CardWars.ModificationLayers.LANDSCAPE_FLIP_DOWN_AVAILABILITY and zone == CardWars.Zones.IN_PLAY then
            local landscape = STATE.Players[me.Original.OwnerI].Landscapes[me.LaneI]
            Common.Flip.DisallowFlipDownFor(landscape, 1 - me.Original.OwnerI)
        end
    end)

    return result
end