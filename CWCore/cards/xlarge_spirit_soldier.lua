-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- Each adjacent Creature has +1 ATK.

        local ownerI = me.Original.OwnerI

        local adjacent = Common.State:AdjacentLandscapes(state, ownerI, me.LaneI)
        for _, landscape in ipairs(adjacent) do
            if landscape.Creature ~= nil then
                landscape.Creature.Attack = landscape.Creature.Attack + 1
            end
        end
    end)

    return result
end