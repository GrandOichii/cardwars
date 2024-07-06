-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Furious Chick has +1 ATK for each Damage on it.
    Common.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + me.Original.Damage
    end)

    return result
end