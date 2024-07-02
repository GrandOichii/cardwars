-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    
    result.EffectP:AddLayer(
        function (id, playerI)
            -- Deal 1 damage to your opponent for each card in his hand

            local opponentI = 1 - playerI
            local count = GetHandCount(opponentI)

            DealDamageToPlayer(opponentI, count)
        end
    )

    return result
end