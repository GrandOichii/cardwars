-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer)
        -- +1 ATK for each adjacent Cornfield Landscape.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI

            local landscapes = Common:AdjacentLandscapesTyped(ownerI, me.LaneI, CardWars.Landscapes.Cornfield)

            me.Attack = me.Attack + #landscapes
        end

    end)

    return result
end