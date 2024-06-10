-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- +1 ATK for each adjacent Cornfield Landscape.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI

            local landscapes = Common.State:AdjacentLandscapes(state, ownerI, me.LaneI)

            for _, landscape in ipairs(landscapes) do
                if landscape:Is('Cornfield') then
                    me.Attack = me.Attack + 1
                end
            end

        end

    end)

    return result
end