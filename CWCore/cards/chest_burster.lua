-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of your turn, deal 3 Damage to each opponent who was no cards in hand.

        trigger = CardWars.Triggers.TURN_START,
        checkF = function (me, ownerI, laneI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI, laneI)
            return true
        end,
        effectF = function (me, ownerI, laneI)
            local opponentI = 1 - ownerI
            local opponent = GetPlayer(ownerI)
            if opponent.Hand.Count == 0 then
                DealDamageToPlayer(opponentI, 3)
            end
        end
    })

    return result
end