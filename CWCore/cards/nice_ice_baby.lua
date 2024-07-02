-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +3 ATK while your opponent does not control a Creature in this Lane.
    Common.State.ModATKDEF(result, function (me)
        local opposing = Common.OpposingCreaturesInLane(me.Original.ControllerI, me.LaneI)
        if #opposing == 0 then
            me.Attack = me.Attack + 3
        end
    end)

    return result
end