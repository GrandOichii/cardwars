-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- While Ms. Fluff has exactly 7 Damage on it, it has +7 ATK.
    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 7 then
            me.Attack = me.Attack + 7
        end
    end)

    return result
end