-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- At the start of your Fight Phase, if you control an exhausted Creature on this Landscape, draw a card.
    CW.Triggers.AtTheStartOfYourFightPhase(result, function (me, controllerI, laneI, args)
        local creatures = Common.CreaturesInLane(controllerI, laneI)
        if #creatures == 0 then
            return
        end

        for _, creature in ipairs(creatures) do
            if creature.Original:IsExhausted() then
                Draw(controllerI, 1)
                return
            end
        end
    end)

    return result
end