-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK for each face-down Landscape in play.
    Common.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + #Common.FaceDownLandscapes(me.Original.ControllerI)
    end)

    return result
end