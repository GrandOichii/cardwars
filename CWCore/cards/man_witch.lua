-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Whenever a foe discards a card, deal 1 Damage to that foe.
    result:AddTrigger({
        trigger = CardWars.Triggers.DISCARD_FROM_HAND,
        checkF = function (me, controllerI, laneI, args)
            return args.Card.OwnerI == (1 - controllerI)
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
            DealDamageToPlayer(args.Card.OwnerI, 1)
        end
    })

    return result
end