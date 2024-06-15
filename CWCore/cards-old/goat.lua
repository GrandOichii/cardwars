-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Goat enters play, if it replaced a Creature, draw a card.

        if replaced then
            Draw(playerI, 1)
        end
    end)

    return result
end