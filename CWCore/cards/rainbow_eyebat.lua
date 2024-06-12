-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.Triggers.AtTheStartOfYourTurn(result, function (me, ownerI, laneI, args)
        local amount = #GetUniqueLandscapeNames(ownerI)
        HealHitPoints(ownerI, amount)
    end)

    return result
end