-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- While your Creature in this Lane has no Damage on it, it has +2 ATK.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local player = STATE.Players[controllerI]
        local lane = player.Landscapes[me.LaneI]

        if lane.Creature ~= nil and lane.Creature.Original.Damage == 0 then
            lane.Creature.Attack = lane.Creature.Attack + 2
        end
    end)

    return result
end