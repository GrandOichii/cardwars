-- Destroy Mace Stump >>> Target opponent discards a card for every 5 cards in your discard pile.

-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.DestroyMe(result, function (me, playerI, laneI)
        local amount = STATE.Players[playerI].DiscardPile.Count
        if amount == 0 then
            return
        end
        amount = math.floor(amount / 5)
        Common.DiscardNCards(1 - playerI, amount)
    end)

    return result
end