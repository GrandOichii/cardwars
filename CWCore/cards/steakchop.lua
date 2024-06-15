-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- At the start of your turn, discard 2 cards or destroy Steakchop. (Discard after your free draw.)
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local accept = YesNo(controllerI, 'Discard 2 cards? ('..me.Original.Template.Name..' will be destroyed otherwise)')
        if not accept then
            DestroyCreature(me.Original.Card.ID)
            return
        end
        Common.DiscardNCards(controllerI, 2)
    end)

    return result
end