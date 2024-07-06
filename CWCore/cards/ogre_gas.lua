-- Status: not implemented

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Reveal the top 3 cards of your deck. Put one of them on the bottom of your deck and discard the rest.
            local amount = 3

            -- TODO? this stops the spell's effect if the player's deck doesn't have 3 cards, change?
            local deckCount = STATE.Players[playerI].Original.Deck.Count
            if deckCount < amount then
                return
            end

            local cards = RevealCardsFromDeck(playerI, amount)
            local options = {}
            for _, card in ipairs(cards) do
                options[#options+1] = card.Template.Name
            end

            local choice = ChooseCard(playerI, options, 'Choose a card to put on the bottom of your deck')
            Mill(playerI, choice)
            FromTopToBottom(playerI, 1)
            Mill(playerI, amount - choice - 1)
        end
    )

    return result
end