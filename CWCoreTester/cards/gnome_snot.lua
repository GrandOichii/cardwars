
function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Draw 3 cards.

            Draw(playerI, 3)
        end
    )

    return result
end