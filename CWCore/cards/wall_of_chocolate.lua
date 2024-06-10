-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- While Wall of Chocolate has no Damage on it, it has +3 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            if me.Original.Damage == 0 then
                me.Attack = me.Attack + 3
            end
        end
    end)

    return result
end