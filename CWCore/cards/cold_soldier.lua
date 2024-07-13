-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +3 ATK while your opponent does not control a Creature in this Lane.
    CW.State.ModATKDEF(result, function (me)
        local creatures = CW.CreatureFilter()
            :InLane(me.LaneI)
            :OpposingTo(me.Original.ControllerI)
            :Do()

        if #creatures > 0 then
            return
        end

        me.Attack = me.Attack + 3
    end)

    return result
end