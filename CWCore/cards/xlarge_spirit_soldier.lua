-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- Each adjacent Creature has +1 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI

            local adjacent = Common.AdjacentCreatures(ownerI, me.LaneI)
            for _, creature in ipairs(adjacent) do
                creature.Attack = creature.Attack + 1
            end
        end
    end)

    return result
end