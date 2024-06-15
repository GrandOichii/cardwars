-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- While Papercut Tiger has exactly 5 Damage on it, it has +5 ATK.
    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 5 then
            me.Attack = me.Attack + 5
        end
    end)

    return result
end