-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- +2 ATK if you control a Blue Plains Landscape.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local id = me.Original.Card.ID

            local lanes = state.Players[ownerI].Landscapes
            for i = 1, lanes.Count do
                local lane = lanes[i - 1]
                if lane.Original:Is('Blue Plains') then
                    me.Attack = me.Attack + 2
                    break
                end
            end

        end
    end)

    return result
end