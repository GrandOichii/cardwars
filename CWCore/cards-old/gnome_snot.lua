-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (playerI)
            -- Draw 3 cards.

            Draw(playerI, 3)
        end
    )

    return result
end