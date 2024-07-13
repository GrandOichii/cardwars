-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, move Drained Cleric to an empty Landscape you control. If you cannot, discard a card.
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local empty = Common.LandscapesWithoutCreatures(controllerI)
        if #empty == 0 then
            CW.Discard.ACard(controllerI)
            return
        end
        local lanes = CW.Lanes(empty)
        local choice = ChooseLandscape(controllerI, lanes, {}, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')
        assert(choice[0] == controllerI, 'tried to choose opponent\'s card (Drained Cleric)')
        MoveCreature(me.Original.IPID, choice[1])
    end)

    return result
end