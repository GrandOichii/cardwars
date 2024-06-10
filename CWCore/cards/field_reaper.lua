-- Status: not implemented - requires implementation of: play checking and additional costs to play

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Cornataur enters play, deal 1 Damage to your opponent for each Cornfield Landscape you control.

        -- local opponentI = 1 - playerI
        -- local count = Common:LandscapesTyped(playerI, CardWars.Landscapes.Cornfield)

        -- DealDamageToPlayer(opponentI, count)
    end)

    return result
end
