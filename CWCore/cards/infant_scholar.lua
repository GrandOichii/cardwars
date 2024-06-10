-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- If you played one or more Rainbow cards this turn, Infant Scholar has +3 ATK this turn,

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local count = Common:CardsPlayedThisTurnTyped(ownerI, CardWars.Landscapes.Rainbow)
            if count > 3 then
                me.Attack = me.Attack + 3
            end
        end
    end)

    return result
end