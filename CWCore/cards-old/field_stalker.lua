-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, each player draws a card.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        for i = 1, 2 do
            Draw(i - 1, 1)
        end
    end)

    return result
end