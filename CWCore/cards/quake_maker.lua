-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK for each face-down Landscape in play.
    CW.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + #CW.LandscapeFilter():FaceDown():Do() * 2
    end)

    return result
end