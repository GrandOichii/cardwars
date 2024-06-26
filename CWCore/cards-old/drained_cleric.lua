-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- At the start of your turn, move Drained Cleric to an empty Landscape you control. If you cannot, discard a card.
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local empty = Common.LandscapesWithoutCreatures(controllerI)
        if #empty == 0 then
            Common.ChooseAndDiscardCard(controllerI)
            return
        end
        local lanes = Common.Lanes(empty)
        local choice = ChooseLandscape(controllerI, lanes, {}, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')
        if choice[0] ~= controllerI then
            error('tried to choose opponent\'s card (Drained Cleric)')
        end
        MoveCreature(me.Original.Card.ID, choice[1])
    end)

    return result
end