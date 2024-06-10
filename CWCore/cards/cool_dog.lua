-- Status: Implemented, requires further testing

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- Your Creatures on adjacent Lanes may not be Attacked.

        -- TODO change layer

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local id = me.Original.Card.ID
            local opponentI = 1 - ownerI
            local opponent = state.Players[opponentI]
            local landscapes = Common.State:AdjacentLandscapes(state, ownerI, me.LaneI)
            local lanes = opponent.Landscapes
            for _, landscape in ipairs(landscapes) do
                if landscape.Creature ~= nil then
                    local laneI = landscape.Creature.LaneI
                    if lanes[laneI].Creature ~= nil then
                        lanes[laneI].Creature.CanAttack = false
                    end
                end
            end
        end

    end)

    return result
end