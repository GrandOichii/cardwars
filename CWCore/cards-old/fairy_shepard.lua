-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Each Adjacent NiceLands Creature has +2 DEF.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local adjacent = Common.AdjacentCreaturesTyped(controllerI, me.LaneI, CardWars.Landscapes.NiceLands)
        for _, creature in ipairs(adjacent) do
            creature.Defense = creature.Defense + 2
        end
    end)

    return result
end