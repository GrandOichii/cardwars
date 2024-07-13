-- Status: Not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, deal 1 Damage to target opponent for every 5 cards in your discard pile.
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local opponentI = 1 - controllerI
        local player = GetPlayer(controllerI)
        local discardCount = player.DiscardPile.Count
        if discardCount == 0 then
            return
        end
        DealDamageToPlayer(opponentI, math.floor(discardCount / 5))
    end)

    return result
end