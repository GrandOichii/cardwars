-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Each adjacent Creature has +1 ATK.
    CW.State.ModATKDEF(result, function (me)
        local creatures = CW.CreatureFilter()
            :AdjacentToLane(me.Original.ControllerI, me.LaneI)
            :Do()
        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 1
        end
    end)

    return result
end