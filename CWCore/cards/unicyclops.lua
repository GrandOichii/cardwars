-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- At the start of your turn, each player draws a card and then discards a card.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, ownerI, laneI, args)
        for i = 0, 1 do
            Draw(i, 1)
            Common.ChooseAndDiscardCard(i, 1)
        end
    end)

    return result
end