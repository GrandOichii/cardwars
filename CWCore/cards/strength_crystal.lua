-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target player draws five cards.

            local target = TargetPlayer(playerI, {0, 1}, 'Choose a player who will draw 5 cards')
            Draw(target, 5)
        end
    )

    return result
end