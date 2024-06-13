-- Status: not implemented - requires implementation of: play checking and additional costs to play

function _Create(props)
    local result = CardWars:Creature(props)

    -- Additional Cost: Discard a card. When Field Reaper enters play, move target Creature in this Lane to an adjacent empty Lane on your side.

    Common.AddRestriction(result,
        function (playerI)
            return nil, GetHandCount(playerI)
        end
    )

    result.PayCostsP:AddLayer(function (playerI, handI)
        Common.ChooseAndDiscardCard(playerI)
        return nil, true
    end)


    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- TODO add stealing
    end)

    return result
end
