-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Icy Infiltrator enters play, Freeze its Landscape.

        CW.Freeze.Landscape(playerI, laneI)
    end)

    return result
end