-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnMoveP:AddLayer(function(playerI, fromI, toI, wasStolen)
        -- When Woadic Marauder changes Lanes during a turn, draw a card.
        -- TODO if Woadic Marauder was stolen, who draws the card?

        Draw(playerI, 1)
    end)

    return result
end
