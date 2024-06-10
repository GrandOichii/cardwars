-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- While Ms. Fluff has exactly 7 Damage on it, it has +7 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            if me.Original.Damage == 7 then
                me.Attack = me.Attack + 7
            end
        end

    end)

    return result
end