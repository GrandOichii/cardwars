-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnMoveP:AddLayer(function(playerI, fromI, toI)
        -- When Woadic Marauder changes Lanes during a turn, draw a card.

        Draw(playerI, 1)
    end)

    return result
end
