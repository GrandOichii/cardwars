-- At the start of your turn, each player draws a card.
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        -- TODO change if multiplayer is implemented
        for i = 0, 1 do
            Draw(i, 1)
        end
    end)

    return result
end