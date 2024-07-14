-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, move Woadic Ring Leader to an empty Landscape you control. If you cannot, destroy it.-
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local empty = CW.LandscapeFilter():ControlledBy(controllerI):Empty():Do()
        local choice = CW.Target.Landscape(empty, controllerI, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')
        if choice == nil then
            DestroyCreature(me.Original.IPID)
            return
        end
        assert(choice.Original.OwnerI == controllerI, 'tried to choose opponent\'s landscape (Woadic Ring Leader)')
        MoveCreature(me.Original.IPID, choice.Original.Idx)
    end)

    return result
end