-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- While Cotton Eyebat has exactly 4 Damage on it, it has +4 ATK.
    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 4 then
            me.Attack = me.Attack + 4
        end
    end)

    return result
end