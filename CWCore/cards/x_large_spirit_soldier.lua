-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Each adjacent Creature has +1 ATK.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local adjacent = Common.AdjacentCreatures(controllerI, me.LaneI)
        for _, creature in ipairs(adjacent) do
            creature.Attack = creature.Attack + 1
        end
    end)

    return result
end