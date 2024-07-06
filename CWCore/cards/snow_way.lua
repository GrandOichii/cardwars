-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Freeze two target Landscapes.

            -- TODO? change
            Common.Freeze.TargetLandscape(playerI)
            Common.Freeze.TargetLandscape(playerI)
        end
    )

    return result
end