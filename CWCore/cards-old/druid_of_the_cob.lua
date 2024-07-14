-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Flooped Creatures you control have +1 ATK.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local creatures = Common.FloopedCreatures(controllerI)

        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 1
        end
    end)

    return result
end