-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, deal 3 Damage to each opponent who was no cards in hand.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI)
        -- TODO change to GetOpponents(playerI) and iterate
        
        local opponentI = 1 - controllerI
        local opponent = GetPlayer(controllerI)
        if opponent.Hand.Count == 0 then
            DealDamageToPlayer(opponentI, 3)
        end
    end)

    return result
end