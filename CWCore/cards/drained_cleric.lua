-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, move Drained Cleric to an empty Landscape you control. If you cannot, discard a card.
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local empty = CW.LandscapeFilter():ControlledBy(controllerI):Empty():Do()
        local choice = CW.Target.Landscape(empty, controllerI, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')
        if choice == nil then
            CW.Discard.ACard(controllerI)
            return
        end
        assert(choice.Original.OwnerI == controllerI, 'tried to choose opponent\'s card (Drained Cleric)')
        MoveCreature(me.Original.IPID, choice.Original.Idx)
    end)

    return result
end