-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Frosted Snowwoman enters play, Freeze both Landscapes in her Lane.
        for i = 0, STATE.Players.Length - 1 do
            Common.FreezeLandscape(i, laneI)
        end
    end)

    return result
end