-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- While Angel Heart has exactly 3 Damage on it, it has +3 ATK.
    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 3 then
            me.Attack = me.Attack + 3
        end
    end)

    return result
end