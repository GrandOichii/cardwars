-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer)
        -- While Cotton Eyebat has exactly 4 Damage on it, it has +4 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            if me.Original.Damage == 4 then
                me.Attack = me.Attack + 4
            end
        end


    end)

    return result
end