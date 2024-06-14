-- Status: not implemented

function _Create(props)
    local result = CardWars:Spell(props)

    -- Reveal the top 3 cards of your deck. Put one of them on the bottom of your deck and discard the rest.
    result.EffectP:AddLayer(
        function (playerI)
            -- 
            
            -- local cards = Common.RevealCardsFromDeck(playerI, 3)
            -- local toBottom = Common.ChooseCard(cards, )
        end
    )

    return result
end