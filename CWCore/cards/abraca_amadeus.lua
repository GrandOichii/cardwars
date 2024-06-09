-- Status: not implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Target opponent discards a card from his hand for every 5 cards in your discard pile.

            Draw(playerI, 3)
        end
    )

    return result
end