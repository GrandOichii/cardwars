-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Lonely Panda enters play, if you control no other Creatures, draw a card.

        UpdateState()
        if #Common.Creatures(playerI) == 1 then
            Draw(playerI, 1)
        end
    end)

    return result
end