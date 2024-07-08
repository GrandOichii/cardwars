-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- Each Creature in this Lane has -1 ATK (min 0).
    Common.State.ModATKDEF(result, function (me)
        local creatures = CW.CreatureFilter():InLane(me.LaneI):Do()
        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack - 1
        end
    end)

    return result
end