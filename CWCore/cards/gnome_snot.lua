-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Draw 3 cards.

            Draw(playerI, 3)
        end
    )

    return result
end