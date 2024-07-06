-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local amount = #GetUniqueLandscapeNames(controllerI)
        HealHitPoints(controllerI, amount)
    end)

    return result
end