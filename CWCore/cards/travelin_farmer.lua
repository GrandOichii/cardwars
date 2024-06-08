-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnLeavePlayP:AddLayer(function(playerI, laneI)
        -- When Travelin' Farmer leaves play, deal 1 Damage to your opponent for each card in his hand.

        local opponentI = 1 - playerI
        local count = GetHandCount(opponentI)
        DealDamageToPlayer(opponentI, count)
    end)

    return result
end
