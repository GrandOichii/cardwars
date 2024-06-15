-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Furious Hen has +1 ATK for each Damage on it.
    Common.State.ModATKDEF(result, function (me)
        me.Attack = me.Attack + me.Original.Damage
    end)

    return result
end