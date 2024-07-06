-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Freeze target Landscape and then draw a card.

            Common.Freeze.TargetLandscape(playerI)
            Draw(playerI, 1)
        end
    )

    return result
end