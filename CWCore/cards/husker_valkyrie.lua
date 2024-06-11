-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer, zone)
        -- Husker Valkyrie has +2 ATK and +2 DEF if you control a Building on this Landscape.

        local ownerI = me.Original.OwnerI

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local lane = me.LaneI
            local landscapes = STATE.Players[ownerI].Landscapes
            if landscapes[lane].Building ~= nil then
                me.Attack = me.Attack + 2
                me.Defense = me.Defense + 2
            end
        end
    
    end)

    return result
end