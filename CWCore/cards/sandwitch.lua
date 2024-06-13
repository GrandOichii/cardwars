-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- When SandWitch or another Creature enters play under your control, deal 1 Damage to your opponent.
    result:AddTrigger({
        trigger = CardWars.Triggers.CREATURE_ENTER,
        checkF = function (me, ownerI, laneI, args)
            return args.ownerI == ownerI
        end,
        costF = function (me, ownerI, laneI, args)
            return true
        end,
        effectF = function (me, ownerI, laneI, args)
            DealDamageToPlayer(1 - ownerI, 1)
        end
    })

    return result
end