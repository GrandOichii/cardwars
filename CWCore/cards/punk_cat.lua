-- Status: implemented
-- TODO? does this effect the opponents creatures?

function _Create(props)
    local result = CardWars:Creature(props)

    -- Each Creature that changed Lanes this turn has +2 ATK his turn.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local creatures = Common.CreaturesThatChangedLanes(ownerI)
        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 2
        end
    end)

    return result
end