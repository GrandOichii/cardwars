-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- Your Creature in this Lane has +1 ATK.

        local ownerI = me.Original.OwnerI
        local player = state.Players[ownerI]
        local lane = player.Landscapes[me.LaneI]
        
        if lane.Creature ~= nil then
            lane.Creature.Attack = lane.Creature.Attack + 1
        end
    end)

    return result
end