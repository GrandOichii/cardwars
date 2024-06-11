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

            for i = 1, count do
                Common.ChooseAndDiscardCard(opponent, 1)
                UpdateState()
            end
        end
    )

    return result
end