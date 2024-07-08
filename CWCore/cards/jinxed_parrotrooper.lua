-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When Jinxed Parrotrooper enters play, move it to any empty Landscape. It cannot be replaced.
    CW.Creature.ParrottrooperEffect(result)

    -- At the start of your turn, discard a card.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        CW.Discard.ACard(controllerI)
    end)

    return result
end