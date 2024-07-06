-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (playerI)
            -- Lose 2 Hit Points, gain 1 Action

            LoseHitPoints(playerI, 2)
            AddActionPoints(playerI, 1)
        end
    )

    return result
end