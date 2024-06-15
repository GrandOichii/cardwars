-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage == 3 then
            me.Attack = me.Attack + 3
        end
    end)

    return result
end