-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Lonely Panda enters play, if you control no other Creatures, draw a card.

        UpdateState()
        if #Common.Creatures(playerI) == 1 then
            Draw(playerI, 1)
        end
    end)

    return result
end