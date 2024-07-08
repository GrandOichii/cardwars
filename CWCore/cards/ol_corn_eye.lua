-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +1 DEF for each different Landscape type you control.
    Common.State.ModATKDEF(result, function (me)
        me.Defense = me.Defense + #GetUniqueLandscapeNames(me.Original.ControllerI)
    end)

    return result
end