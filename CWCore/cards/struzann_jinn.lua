-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK for each Flooped Creature you control.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local creatures = Common.FloopedCreatures(controllerI)
        me.Attack = me.Attack + #creatures * 2
    end)

    return result
end