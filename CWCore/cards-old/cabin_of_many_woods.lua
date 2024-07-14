-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    Common.State.ModCostInHand(result, function (me)
        local ownerI = me.Original.OwnerI
        local count = #Common.FloopedCreatures(ownerI)
        Common.Mod.Cost(me, -count)
    end)

    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local player = STATE.Players[controllerI]
        local lane = player.Landscapes[me.LaneI]

        if lane.Creature ~= nil then
            lane.Creature.Defense = lane.Creature.Defense + 5
        end
    end)

    return result
end