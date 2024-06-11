-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Draw 4 cards, then discard 2 cards.

            Draw(playerI, 4)
            Common.DiscardNCards(playerI, 2)
        end
    )

    return result
end