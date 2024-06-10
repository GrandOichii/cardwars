-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    result:AddStateModifier(function (state, me, layer)
        -- Flooped Creatures you control have +1 ATK.
    
        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local id = me.Original.Card.ID

            local creatures = Common.State:FilterCreatures(state, function (creature)
                return
                    creature.Original.OwnerI == ownerI and
                    creature.Original:IsFlooped()
            end)

            for _, creature in ipairs(creatures) do
                creature.Attack = creature.Attack + 1
            end

        end
    
    end)

    return result
end