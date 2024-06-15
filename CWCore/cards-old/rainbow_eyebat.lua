-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local amount = #GetUniqueLandscapeNames(controllerI)
        HealHitPoints(controllerI, amount)
    end)

    return result
end