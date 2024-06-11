-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Rainbow Creatures you control have +1 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local creatures = Common.CreaturesTyped(me.OwnerI, CardWars.Landscapes.Rainbow)
            for _, creature in ipairs(creatures) do
                creature.Attack = creature.Attack + 1
            end
        end
    
    end)

    return result
end