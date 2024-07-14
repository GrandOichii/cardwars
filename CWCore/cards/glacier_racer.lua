-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +4 ATK if both Landscapes in this Lane have Frozen tokens on them.
    CW.State.ModATKDEF(result, function (me)
        local count = #CW.LandscapeFilter()
            :OnLane(me.LaneI)
            :IsFrozen()
            :Do()

        if count ~= 2 then
            return
        end

        me.Attack = me.Attack + 4

    end)

    return result
end