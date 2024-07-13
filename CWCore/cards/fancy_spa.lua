-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- At the start of your Fight Phase, if you control an exhausted Creature on this Landscape, draw a card.
    CW.Triggers.AtTheStartOfYourFightPhase(result, function (me, controllerI, laneI, args)
        local creatures = CW.CreatureFilter()
            :ControlledBy(controllerI)
            :InLane(laneI)
            :Exhausted()
            :Do()

        if #creatures == 0 then
            return
        end

        Draw(controllerI, 1)
    end)

    return result
end