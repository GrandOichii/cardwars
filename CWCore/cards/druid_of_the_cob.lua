-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    result:AddStateModifier(function (me, layer)
        -- Flooped Creatures you control have +1 ATK.
    
        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI

            local creatures = Common.FloopedCreatures(ownerI)

            for _, creature in ipairs(creatures) do
                creature.Attack = creature.Attack + 1
            end

        end
    
    end)

    return result
end