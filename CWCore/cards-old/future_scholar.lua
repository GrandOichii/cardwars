-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Future Scholar enters play, if it replaced a Creature, gain 1 Action.

        if replaced then
            AddActionPoints(playerI, 1)
        end
    end)

    return result
end