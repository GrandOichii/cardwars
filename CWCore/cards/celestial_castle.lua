-- Status: implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local player = STATE.Players[ownerI]
        local lane = player.Landscapes[me.LaneI]

        if lane.Creature ~= nil then
            lane.Creature.Defense = lane.Creature.Defense + 3
        end
    end)

    return result
end