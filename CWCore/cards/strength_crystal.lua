-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Target player draws five cards.

            local target = TargetPlayer(playerI, {0, 1}, 'Choose a player who will draw 5 cards')
            Draw(target, 5)
        end
    )

    return result
end