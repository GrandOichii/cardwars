-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    -- +2 ATK for each of your empty Lanes.
    Common.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + #Common.EmptyLandscapes(me.Original.ControllerI) * 2
    end)

    return result
end