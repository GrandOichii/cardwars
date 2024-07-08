-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +1 ATK for each different Landscape type you control.
    Common.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + #GetUniqueLandscapeNames()
    end)

    return result
end