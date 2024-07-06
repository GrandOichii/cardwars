-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, put the top card of your deck into your discard pile.
    Common.Triggers.AtTheStartOfYourTurn(result,
        function (me, controllerI, laneI, args)
            Mill(controllerI, 1)
        end
    )

    return result
end