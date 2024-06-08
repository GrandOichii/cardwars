-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- +1 ATK for each adjacent Cornfield Landscape.

        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID

        local landscapes = Common.State:AdjacentLandscapes(state, ownerI, me.LaneI)

        for _, landscape in ipairs(landscapes) do
            if landscape.Name == 'Corn' then
                me.Attack = me.Attack + 1
            end
        end
    end)

    return result
end