-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK for each of your empty Lanes.
    CW.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + #CW.LandscapeFilter():ControlledBy(me.Original.ControllerI):Empty():Do() * 2
    end)

    return result
end