-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Furious Rooster has +1 ATK for each Damage on it.
    CW.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + me.Original.Damage
    end)

    return result
end