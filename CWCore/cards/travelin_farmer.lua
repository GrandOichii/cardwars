-- Status: implemented
-- TODO? does replacing count

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(playerI, laneI, wasReady)
        -- When Travelin' Farmer leaves play, deal 1 Damage to your opponent for each card in his hand.

        local opponentI = 1 - playerI
        local count = GetHandCount(opponentI)
        DealDamageToPlayer(opponentI, count)
    end)

    return result
end
