-- Status: implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    -- Your Creature in this Lane has +1 ATK.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local player = STATE.Players[controllerI]
        local lane = player.Landscapes[me.LaneI]

        if lane.Creature ~= nil then
            lane.Creature.Attack = lane.Creature.Attack + 1
        end
    end)

    return result
end