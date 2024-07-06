-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Tough Lumberjill enters play, deal 1 Damage to your opponent for each Building you control.
    
        local buildings = Common.Buildings(playerI)
        DealDamageToPlayer(1 - playerI, #buildings)
    end)

    return result
end