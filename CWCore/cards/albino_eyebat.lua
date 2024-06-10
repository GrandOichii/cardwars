-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- While Albino Eyebat has exactly 2 Damage on it, it has +2 ATK.

        if me.Original.Damage == 2 then
            me.Attack = me.Attack + 2
        end
    end)

    return result
end