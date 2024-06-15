-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Grape Djini enters play, if it replaced a Creature, you may put a card from your discard pile on top of your deck.

        if not replaced then
            return
        end

        local choices = Common.DiscardPileCardIndicies(playerI, function (card)
            return card.Original.Template.Type == 'Creature'
        end)

        if #choices == 0 then
            return
        end

        local choice = ChooseCardInDiscard(playerI, choices, {}, 'Choose a Creature card to place on top of your deck')
        local pI = choice[0]
        if pI ~= playerI then
            -- * shouldn't ever happen
            error('tried to pick card in opponent\'s discard (Grape Djini)')
            return
        end
        local idx = choice[1]

        local card = STATE.Players[playerI].DiscardPile[idx]
        local accept = YesNo(playerI, 'Place '..card.Original.Template.Name..' on top of your deck?')
        if not accept then
            return
        end

        PlaceFromDiscardOnTopOfDeck(playerI, idx)
end)

    return result
end