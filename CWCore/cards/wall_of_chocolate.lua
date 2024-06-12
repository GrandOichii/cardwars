-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- While Wall of Chocolate has no Damage on it, it has +3 ATK.
    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 0 then
            me.Attack = me.Attack + 3
        end
    end)

    return result
end