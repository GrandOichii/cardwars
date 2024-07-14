-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, move Tired Wombat to an empty Landscape you control. If you cannot, move it to an empty Landscape your opponent controls.
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local empty = CW.LandscapeFilter()
            :ControlledBy(controllerI)
            :Empty()
            :Do()
        local choice = CW.Target.Landscape(empty, controllerI, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')

        if choice == nil then
            local oempty = CW.LandscapeFilter()
                :ControlledBy(1 - controllerI)
                :Empty()
                :Do()
            local ochoice = CW.Target.Landscape(oempty, controllerI, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')
            if ochoice == nil then
                return
            end
            assert(ochoice.Original.OwnerI == (1 - controllerI), 'tried to choose controller\'s landscape (Tired Wombat)')
            StealCreature(controllerI, me.Original.IPID, ochoice.Original.Idx)
            return
        end

        assert(choice.Original.OwnerI == controllerI, 'tried to choose opponent\'s landscape (Tired Wombat)')
        MoveCreature(me.Original.IPID, choice.Original.Idx)
    end)

    return result
end