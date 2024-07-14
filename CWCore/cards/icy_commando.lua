-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    -- Icy Commando has +1 ATK for each Landscape with a Frozen token on it.
    CW.State.ModATKDEF(result, function (me)
        local landscapes = CW.LandscapeFilter():IsFrozen():Do()
        local amount = #landscapes
        me.Attack = me.Attack + amount
    end)

    return result
end