-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Corn Lord has +1 ATK for each other Cornfield Creature you control. 

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI
            local id = me.Original.Card.ID

            local creatures = Common.CreaturesTypedExcept(ownerI, CardWars.Landscapes.Cornfield, id)

            me.Attack = me.Attack + #creatures
        end

    end)

    return result
end