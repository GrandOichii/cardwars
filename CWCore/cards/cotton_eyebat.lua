-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- While Angel Heart has exactly 4 Damage on it, it has +4 ATK.

        if me.Original.Damage == 4 then
            me.Attack = me.Attack + 4
        end
    end)

    return result
end