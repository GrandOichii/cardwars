-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Husker Valkyrie has +2 ATK and +2 DEF if you control a Building on this Landscape.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local lane = me.LaneI
        local landscapes = STATE.Players[controllerI].Landscapes
        if landscapes[lane].Building ~= nil then
            me.Attack = me.Attack + 2
            me.Defense = me.Defense + 2
        end
    end)

    return result
end