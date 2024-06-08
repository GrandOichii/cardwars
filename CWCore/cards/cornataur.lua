-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI)
        -- When Cornataur enters play, deal 1 Damage to your opponent for each Cornfield Landscape you control.

        local opponentI = 1 - playerI
        local count = 0
        local lanes = GetLanes(playerI)
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane:Is('Cornfield') then
                count = count + 1
            end
        end

        DealDamageToPlayer(opponentI, count)
    end)

    return result
end
