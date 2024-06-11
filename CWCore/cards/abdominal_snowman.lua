
-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer, zone)
        -- +3 ATK while your opponent does not control a Creature in this Lane.

        -- ! copied code from Nice Ice Baby
        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI
            local opponentI = 1 - ownerI

            local opponent = STATE.Players[opponentI]
            local lanes = opponent.Landscapes
            local lane = lanes[me.LaneI]
            if lane.Creature == nil then
                me.Attack = me.Attack + 3
            end

        end

    end)

    return result
end