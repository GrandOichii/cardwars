-- Status: not implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- 
            
            
        end
    )

    return result
end