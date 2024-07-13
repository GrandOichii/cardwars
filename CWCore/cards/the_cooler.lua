-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(ipid, id, playerI, laneI, wasReady)
        -- When The Cooler leaves play, Freeze its Landscape.

        CW.Freeze.Landscape(playerI, laneI)
    end)

    return result
end