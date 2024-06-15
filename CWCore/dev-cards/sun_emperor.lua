-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Sun Emperor counts as an additional 2 Cornfield Landscapes you control.

        if layer == CardWars.ModificationLayers.ADDITIONAL_LANDSCAPES and zone == CardWars.Zones.IN_PLAY then
            me.CountsAsLandscapes:Add('Cornfield')
            me.CountsAsLandscapes:Add('Cornfield')
        end

    end)

    return result
end