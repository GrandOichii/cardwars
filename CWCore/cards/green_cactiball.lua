-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- +2 ATK for each Green Cactiball you control.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI
            local count = Common.CreaturesNamed(ownerI, 'Green Cactiball')

            me.Attack = me.Attack + #count * 2
        end
        
    end)

    return result
end