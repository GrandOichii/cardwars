-- Status: implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (state, me, layer)
        -- Your Creature in this Lane has +1 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local player = state.Players[ownerI]
            local lane = player.Landscapes[me.LaneI]
    
            if lane.Creature ~= nil then
                lane.Creature.Attack = lane.Creature.Attack + 1
            end
            
        end
    end)

    return result
end