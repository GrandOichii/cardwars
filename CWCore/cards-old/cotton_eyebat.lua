-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 4 then
            me.Attack = me.Attack + 4
        end
    end)

    return result
end