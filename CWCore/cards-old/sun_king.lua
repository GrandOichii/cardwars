-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- Sun King counts as an additional Cornfield Landscape you control.

        if layer == CardWars.ModificationLayers.ADDITIONAL_LANDSCAPES and zone == CardWars.Zones.IN_PLAY then
            me.CountsAsLandscapes:Add('Cornfield')
        end

    end)

    return result
end