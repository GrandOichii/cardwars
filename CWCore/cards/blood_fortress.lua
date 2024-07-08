-- Status: implemented

function _Create()
    local result = CardWars:InPlay()

    -- Your Creature in this Lane has +1 ATK.
    CW.State.ModATKDEF(result, function (me)
        local creatures = CW.CreatureFilter()
            :ControlledBy(me.Original.ControllerI)
            :InLane(me.LaneI)
            :Do()
        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 1
        end
    end)

    return result
end