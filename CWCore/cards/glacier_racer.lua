-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    -- +4 ATK if both Landscapes in this Lane have Frozen tokens on them.
    Common.State.ModATKDEF(result, function (me)
        local laneI = me.LaneI
        for i = 0, STATE.Players.Length - 1 do
            local landscape = STATE.Players[i].Landscapes[laneI]
            if not landscape:IsFrozen() then
                return
            end
        end
        me.Attack = me.Attack + 4

    end)

    return result
end