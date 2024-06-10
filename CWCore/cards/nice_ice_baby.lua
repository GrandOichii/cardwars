-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- +3 ATK while your opponent does not control a Creature in this Lane.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then

            local ownerI = me.Original.OwnerI
            local opponentI = 1 - ownerI
            local id = me.Original.Card.ID

            local opponent = state.Players[opponentI]
            local lanes = opponent.Landscapes
            local lane = lanes[me.LaneI]
            local mod = 0
            if lane.Creature == nil then
                mod = 3
            end

            me.Attack = me.Attack + mod

        end

    end)

    return result
end