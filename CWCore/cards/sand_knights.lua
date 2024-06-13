-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- +2 ATK if you control a Blue Plains Landscape.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local landscapes = Common.LandscapesTyped(controllerI, CardWars.Landscapes.BluePlains)
        if #landscapes > 0 then
            me.Attack = me.Attack + 2
        end
    end)

    return result
end