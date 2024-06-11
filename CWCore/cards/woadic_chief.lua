-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- Woadic Chief has +2 ATK this turn for each Spell you have played this turn.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI
            local count = Common.SpellsPlayedThisTurn(ownerI)

            me.Attack = me.Attack + count * 2

        end
    end)

    return result
end