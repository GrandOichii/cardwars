-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Lose 2 Hit Points, gain 1 Action

            LoseHitPoints(playerI, 2)
            AddActionPoints(playerI, 1)
        end
    )

    return result
end