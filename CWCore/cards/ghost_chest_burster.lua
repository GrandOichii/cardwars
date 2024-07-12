-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(ipid, id, playerI, laneI, wasReady)
        -- When Ghost Chest Burster leaves play, draw the bottom card of your deck.

        DrawFromBottom(playerI, 1)
    end)

    return result
end