-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When Dragoon Parrotrooper enters play, move it to any empty Landscape. It cannot be replaced.
    CW.Creature.ParrottrooperEffect(result)

    -- Adjacent Creatures have - 1 ATK.
    Common.State.ModATKDEF(result, function (me)
        local creatures = CW.CreatureFilter()
            :ControlledBy(me.Original.ControllerI)
            :AdjacentToLane(me.LaneI)
            :Do()

        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack - 1
        end
    end)

    return result
end