-- Status: Not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- At the start of your turn, deal 1 Damage to target opponent for every 5 cards in your discard pile.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
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