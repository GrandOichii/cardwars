-- Status: Implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Deal 1 damage to your opponent for each card in his hand

            local opponentI = 1 - playerI
            local count = GetHandCount(opponentI)

            DealDamageToPlayer(opponentI, count)
        end
    )

    return result
end