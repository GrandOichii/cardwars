-- Status: Not implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- TODO add activated abiltity
    result:AddTrigger({
        trigger = CardWars.Triggers.TurnStart,
        checkF = function (me, ownerI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI)
            return true
        end,
        effectF = function (me, ownerI)
            local opponentI = 1 - ownerI
            local opponent = GetPlayer(ownerI)
            if opponent.Hand.Count == 0 then
                DealDamageToPlayer(opponentI, 3)
            end
        end
    })

    return result
end