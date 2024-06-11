-- Status: Not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of your turn, deal 1 Damage to target opponent for every 5 cards in your discard pile.

        trigger = CardWars.Triggers.TURN_START,
        checkF = function (me, ownerI, laneI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI, laneI)
            return true
        end,
        effectF = function (me, ownerI, laneI)
            local opponentI = 1 - ownerI
            local player = GetPlayer(ownerI)
            local discardCount = player.DiscardPile.Count
            if discardCount == 0 then
                return
            end
            DealDamageToPlayer(opponentI, math.floor(discardCount / 5))
        end
    })

    return result
end