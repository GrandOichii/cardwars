-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- While Ms. Fluff has exactly 7 Damage on it, it has +7 ATK.

        if me.Original.Damage == 7 then
            me.Attack = me.Attack + 7
        end
    end)

    return result
end