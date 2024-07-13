-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Each Adjacent NiceLands Creature has +2 DEF.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local adjacent = CW.CreatureFilter()
            :ControlledBy(controllerI)
            :AdjacentToLane(me.LaneI)
            :LandscapeType(CardWars.Landscapes.NiceLands)
            :Do()
        for _, creature in ipairs(adjacent) do
            creature.Defense = creature.Defense + 2
        end
    end)

    return result
end