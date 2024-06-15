-- At the start of your turn, put the top card of your deck into your discard pile.

-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.Triggers.AtTheStartOfYourTurn(result,
        function (me, controllerI, laneI, args)
            Mill(controllerI, 1)
        end
    )

    return result
end