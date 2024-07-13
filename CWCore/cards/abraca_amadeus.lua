-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'opponentIdx',
                target = CW.Spell.Target.Opponent()
            }
        },
        function (id, playerI, targets)
            -- Target opponent discards a card from his hand for every 5 cards in your discard pile.
            local idx = targets.opponentIdx
            local count = GetPlayer(idx).DiscardPile.Count
            if count == 0 then
                return
            end
            CW.Discard.NCards(idx, math.floor(count / 5))
        end
    )

    return result
end