-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- +3 ATK while your opponent does not control a Creature in this Lane.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local opponentI = 1 - ownerI

        local opponent = STATE.Players[opponentI]
        local lanes = opponent.Landscapes
        local lane = lanes[me.LaneI]

        if lane.Creature == nil then
            me.Attack = me.Attack + 3
        end

    end)

    return result
end