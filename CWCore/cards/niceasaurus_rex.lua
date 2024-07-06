-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:AddTrigger({
        trigger = CardWars.Phases.START,
        checkF = function (me, controllerI, laneI, args)
            return args.playerI == controllerI and me.Original.Damage > 0
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI)
            Draw(controllerI, 1)
        end
    })

    return result
end