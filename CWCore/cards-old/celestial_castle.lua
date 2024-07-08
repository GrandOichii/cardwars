-- Status: implemented

function _Create()
    local result = CardWars:InPlay()

    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local player = STATE.Players[controllerI]
        local lane = player.Landscapes[me.LaneI]

        if lane.Creature ~= nil then
            lane.Creature.Defense = lane.Creature.Defense + 3
        end
    end)

    return result
end