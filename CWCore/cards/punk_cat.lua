-- Status: implemented
-- TODO? does this effect the opponents creatures?

function _Create()
    local result = CardWars:Creature()

    -- Each Creature that changed Lanes this turn has +2 ATK his turn.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local creatures = CW.CreatureFilter():ControlledBy(controllerI):MovedThisTurn():Do()
        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 2
        end
    end)

    return result
end