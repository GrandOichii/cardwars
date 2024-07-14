-- Status: not tested, requires further testing

function _Create()
    local result = CardWars:Creature()

    -- Your Creatures on adjacent Lanes may not be Attacked.
    CW.State.ModAttackRight(result, function (me)
        local controllerI = me.Original.ControllerI
        local adjacent = Common.AdjacentCreatures(controllerI, me.LaneI)
        for _, creature in ipairs(adjacent) do
            Common.State.CantBeAttacked(creature)
        end

    end)

    return result
end