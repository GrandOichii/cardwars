-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- Each adjacent Creature has +1 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI

            local adjacent = Common:AdjacentLandscapes( ownerI, me.LaneI)
            for _, landscape in ipairs(adjacent) do
                if landscape.Creature ~= nil then
                    landscape.Creature.Attack = landscape.Creature.Attack + 1
                end
            end
        end
    end)

    return result
end