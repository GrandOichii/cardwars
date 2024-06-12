-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
        if me.Original.Damage >= 4 then
            me.Attack = me.Attack + 2
        end
    end)

    return result
end