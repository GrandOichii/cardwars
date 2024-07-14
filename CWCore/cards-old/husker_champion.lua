-- Status: implemented

function _Create()
    local result = CardWars:Creature()
    
    -- Husker Champion has +2 ATK and +2 DEF if you control a Building on this Landscape.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local laneI = me.LaneI
        if STATE.Players[controllerI].Landscapes[laneI].Building ~= nil then
            me.Attack = me.Attack + 2
            me.Defense = me.Defense + 2
        end
    end)

    return result
end