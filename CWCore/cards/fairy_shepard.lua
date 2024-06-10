-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer)
        -- Each Adjacent NiceLands Creature has +2 DEF.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then

            local ownerI = me.Original.OwnerI

            local adjacent = Common:AdjacentLandscapes(ownerI, me.LaneI)
            for _, landscape in ipairs(adjacent) do
                if landscape.Creature ~= nil and landscape.Creature.Original.Card.Template == 'NiceLands' then
                    landscape.Creature.Defense = landscape.Creature.Defense + 2
                end
            end

        end

    end)

    return result
end