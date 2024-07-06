-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, you heal 1 Hit Point for each different Landscape type you control. (Can 't go over 25.)
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local amount = #GetUniqueLandscapeNames(controllerI)
        HealHitPoints(controllerI, amount)
    end)

    return result
end