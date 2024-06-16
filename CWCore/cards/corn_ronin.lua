-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local landscapes = Common.AdjacentLandscapesTyped(controllerI, me.LaneI, CardWars.Landscapes.Cornfield)

        me.Attack = me.Attack + #landscapes
    end)

    return result
end