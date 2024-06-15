-- Target player draws five cards.
-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- 
            
            -- local player = Common.TargetablePlayer()
            -- !FIXME repquires player targeting
        end
    )

    return result
end