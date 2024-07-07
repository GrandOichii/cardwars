-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(id, playerI, laneI, wasReady)
        -- When The Cooler leaves play, Freeze its Landscape.

        Common.FreezeLandscape(playerI, laneI)
    end)

    return result
end