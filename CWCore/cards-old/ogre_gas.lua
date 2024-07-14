-- Status: not implemented

function _Create()
    local result = CardWars:Spell()

    -- Reveal the top 3 cards of your deck. Put one of them on the bottom of your deck and discard the rest.
    result.EffectP:AddLayer(
        function (playerI)
            -- 

            local amount = 3
            local cards = RevealCardsFromDeck(playerI, amount)
            local options = {}
            for _, card in ipairs(cards) do
                options[#options+1] = card.Template.Name
            end

            local choice = ChooseCard(playerI, options, 'Choose a card to put on the bottom of your deck')
            -- amount = 3
            -- choice = 0
            Mill(playerI, choice)
            FromTopToBottom(playerI, 1)
            Mill(playerI, amount - choice - 1)
        end
    )

    return result
end