-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target player discards 1 card from her hand for each Landscape with a Frozen token on it she controls.

            local target = TargetPlayer(playerI, {0, 1}, 'Choose a player')
            local landscapes = Common.FrozenLandscapes(target)
            Common.DiscardNCards(target, #landscapes)
        end
    )

    return result
end