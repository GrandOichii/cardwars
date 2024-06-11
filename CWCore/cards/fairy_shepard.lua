-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer)
        -- Each Adjacent NiceLands Creature has +2 DEF.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then

            local ownerI = me.Original.OwnerI

            local adjacent = Common.AdjacentCreaturesTyped(ownerI, me.LaneI, CardWars.Landscapes.NiceLands)
            for _, creature in ipairs(adjacent) do
                creature.Defense = creature.Defense + 2
            end

        end

    end)

    return result
end