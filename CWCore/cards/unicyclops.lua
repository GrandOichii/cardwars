-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, each player draws a card and then discards a card.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        for i = 0, 1 do
            Draw(i, 1)
            Common.ChooseAndDiscardCard(i)
        end
    end)

    return result
end