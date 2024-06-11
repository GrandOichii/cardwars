-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Target opponent discards a card from his hand for every 5 cards in your discard pile.
            local opponent = Common.TargetOpponent(playerI)
            local count = GetPlayer(playerI).DiscardPile.Count
            if count == 0 then
                return
            end

            Common.DiscardNCards(opponent, count)
        end
    )

    return result
end