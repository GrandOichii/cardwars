-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer, zone)
        -- Husker Knight has +1 ATK and +2 DEF for each Cornfield Landscape you control. 

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI
            local count = #Common.LandscapesTyped(ownerI, CardWars.Landscapes.Cornfield)
            
            me.Attack = me.Attack + count
            me.Defense = me.Defense + count * 2
        end

    end)

    return result
end