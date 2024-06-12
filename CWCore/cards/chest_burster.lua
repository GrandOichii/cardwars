-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- At the start of your turn, deal 3 Damage to each opponent who was no cards in hand.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, ownerI, laneI)
        -- TODO change to GetOpponents(playerI) and iterate
        
        local opponentI = 1 - ownerI
        local opponent = GetPlayer(ownerI)
        if opponent.Hand.Count == 0 then
            DealDamageToPlayer(opponentI, 3)
        end
    end)

    return result
end