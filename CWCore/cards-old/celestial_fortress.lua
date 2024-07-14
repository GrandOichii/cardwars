-- Status: partially implemented

function _Create()
    local result = CardWars:InPlay()

    CW.State.ModATKDEF(result, function (me)
        local landscape = STATE.Players[1 - me.Original.ControllerI].Landscapes[me.LaneI]
        if landscape.Creature ~= nil then
            landscape.Creature.Defense = landscape.Creature.Defense - 2
        end
    end)

    return result
end