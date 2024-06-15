-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local landscapes = Common.AdjacentLandscapesTyped(controllerI, me.LaneI, CardWars.Landscapes.Cornfield)

        me.Attack = me.Attack + #landscapes
    end)

    return result
end