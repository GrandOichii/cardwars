-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    Common.State.ModCostInHand(result, function (me)
        local ownerI = me.Original.OwnerI
        local count = #Common.FloopedCreatures(ownerI)
        Common.Mod.Cost(me, -count)
    end)

    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local player = STATE.Players[ownerI]
        local lane = player.Landscapes[me.LaneI]

        if lane.Creature ~= nil then
            lane.Creature.Defense = lane.Creature.Defense + 5
        end
    end)

    return result
end