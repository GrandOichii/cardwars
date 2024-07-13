-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Grape Djini enters play, if it replaced a Creature, you may put a card from your discard pile on top of your deck.

        if not replaced then
            return
        end

        local choices = CW.CardsInDiscardPileFilter()
            :OfPlayer(playerI)
            :Do()

        local choice = CW.Choose.CardInDiscardPile(playerI, choices, 'Choose a card in your discard pile to place on top of your deck.')
        if choice == nil then
            return
        end

        if #choices == 0 then
            return
        end

        local pI = choice.playerI
        assert(pI == playerI, 'tried to pick card in opponent\'s discard (Grape Djini)')

        local idx = choice.idx

        local card = STATE.Players[playerI].DiscardPile[idx]
        local accept = YesNo(playerI, 'Place '..card.Original.Template.Name..' on top of your deck?')
        if not accept then
            return
        end

        PlaceFromDiscardOnTopOfDeck(playerI, idx)
end)

    return result
end