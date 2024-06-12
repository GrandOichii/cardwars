-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Flooped Creatures you control have +1 ATK.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI

        local creatures = Common.FloopedCreatures(ownerI)

        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 1
        end
    end)

    return result
end