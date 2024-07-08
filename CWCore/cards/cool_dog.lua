-- Status: implemented, CW

function _Create()
    local result = CardWars:Creature()

    -- Your Creatures on adjacent Lanes may not be Attacked.
    CW.State.ModAttackRight(result, function (me)
        local creatures = CW.CreatureFilter()
            :AdjacentToLane(me.LaneI)
            :ControlledBy(me.Original.ControllerI)
            :Do()
        for _, creature in ipairs(creatures) do
            CW.State.CantBeAttacked(creature)
        end
    end)

    return result
end