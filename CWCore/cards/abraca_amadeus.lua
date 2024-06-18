-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target opponent discards a card from his hand for every 5 cards in your discard pile.
            local opponent = Common.TargetOpponent(playerI)
            local count = GetPlayer(playerI).DiscardPile.Count
            if count == 0 then
                return
            end

            Common.DiscardNCards(opponent, math.floor(count / 2))
        end
    )

    return result
end