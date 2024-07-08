-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Kernel Queen has +1 ATK for each Flooped Creature you control.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local creatures = Common.FloopedCreatures(controllerI)

        me.Attack = me.Attack + #creatures
        me.Defense = me.Defense + #creatures
    end)

    return result
end