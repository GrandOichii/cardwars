-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Your Creatures on adjacent Lanes may not be Attacked.
    Common.State.ModAttackRight(result, function (me)
        local controllerI = me.Original.ControllerI
        local adjacent = Common.AdjacentCreatures(1 - controllerI, me.LaneI)
        for _, creature in ipairs(adjacent) do
            Common.State.CantBeAttacked(creature)
        end

    end)
    

    return result
end