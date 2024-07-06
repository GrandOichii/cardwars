-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When SandWitch or another Creature enters play under your control, deal 1 Damage to your opponent.
    result:AddTrigger({
        trigger = CardWars.Triggers.CREATURE_ENTER,
        checkF = function (me, controllerI, laneI, args)
            return args.controllerI == controllerI
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
            DealDamageToPlayer(1 - controllerI, 1)
        end
    })

    return result
end