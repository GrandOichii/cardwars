-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- While Angel Heart has exactly 3 Damage on it, it has +3 ATK.

        if me.Original.Damage == 3 then
            me.Attack = me.Attack + 3
        end
    end)

    return result
end