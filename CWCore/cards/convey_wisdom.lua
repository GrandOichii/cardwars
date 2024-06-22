-- Status: not tested

function _Create()
    local result = CardWars:Spell()
    
    result.EffectP:AddLayer(
        function (id, playerI)
            -- Look at the top 4 cards of target player's deck and put them back in any order. Then draw a card.
            
            local target = TargetPlayer(playerI, {0, 1}, 'Choose a player to look at the top 4 cards of their deck')
            -- TODO not implemented, throws exception 
    
            -- local deck = STATE.Players[target].Original.Deck:ToList()
            -- local count = 4
            -- if deck.Count >= count then
            --     local cards = {}
            --     for i = 1, count do
            --         cards[#cards+1] = deck[deck.Count - i]
            --     end
            --     while #cards > 0 do
            --         local choices = {}
            --         for _, card in ipairs(cards) do
            --             choices[#choices+1] = card.Template.Name
            --         end
            --         local choice = PickString(playerI, choices, 'Choose a card to place on top')
            --         local i = -1
            --         for index, name in ipairs(choices) do
            --             if name == choice then
            --                 i = index
            --                 break
            --             end
            --         end
            --         FloatToTopOfDeck(target, cards[i])
            --         local newCards = {}
            --         for index, card in ipairs(cards) do
            --             if index ~= i then
            --                 newCards[#newCards+1] = card
            --             end
            --         end
            --         cards = newCards
            --     end
            -- end
            -- Draw(playerI, 1)
        end
    )

    return result
end