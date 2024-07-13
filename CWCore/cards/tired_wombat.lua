-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, move Tired Wombat to an empty Landscape you control. If you cannot, move it to an empty Landscape your opponent controls.
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local empty = Common.LandscapesWithoutCreatures(controllerI)
        if #empty == 0 then
            local lanes = CW.Lanes(Common.LandscapesWithoutCreatures(1 - controllerI))
            if #lanes == 0 then
                return
            end

            local choice = ChooseLandscape(controllerI, {}, lanes, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')
            assert(choice[0] == (1 - controllerI), 'tried to choose controller\'s landscape (Tired Wombat)')
            StealCreature(controllerI, me.Original.IPID, choice[1])
            return
        end
        local lanes = CW.Lanes(empty)
        local choice = ChooseLandscape(controllerI, lanes, {}, 'Choose a landscape to move '..me.Original.Card.LogFriendlyName..' to')
        assert(choice[0] == controllerI, 'tried to choose opponent\'s landscape (Tired Wombat)')
        MoveCreature(me.Original.IPID, choice[1])
    end)

    return result
end