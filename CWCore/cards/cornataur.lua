-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Cornataur enters play, deal 1 Damage to your opponent for each Cornfield Landscape you control.

        local opponentI = 1 - playerI
        local count = #CW.LandscapeFilter()
            :ControlledBy(playerI)
            :OfLandscapeType(CardWars.Landscapes.Cornfield)
            :Do()
        DealDamageToPlayer(opponentI, count)
    end)

    return result
end
