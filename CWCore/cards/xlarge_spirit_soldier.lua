-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- Each adjacent Creature has +1 ATK.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local adjacent = Common.AdjacentCreatures(ownerI, me.LaneI)
        for _, creature in ipairs(adjacent) do
            creature.Attack = creature.Attack + 1
        end
    end)

    return result
end