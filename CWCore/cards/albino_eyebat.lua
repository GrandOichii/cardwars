-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- While Albino Eyebat has exactly 2 Damage on it, it has +2 ATK.
    CW.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 2 then
            me.Attack = me.Attack + 2
        end
    end)

    return result
end