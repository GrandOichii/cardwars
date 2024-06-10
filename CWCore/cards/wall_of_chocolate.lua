-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- While wall of chocolate has no Damage on it, it has +3 ATK.

        if me.Original.Damage == 0 then
            me.Attack = me.Attack + 3
        end
    end)

    return result
end