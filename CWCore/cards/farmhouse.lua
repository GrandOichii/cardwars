-- Farmhouse counts as an additional Cornfield Landscape you control.
-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (me, layer, zone)
        -- 
    
        if layer == CardWars.ModificationLayers.ADDITIONAL_LANDSCAPES and zone == CardWars.Zones.IN_PLAY then
            me.CountsAsLandscapes:Add('Cornfield')
        end
    
    end)

    return result
end