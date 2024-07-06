-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- +3 ATK while your opponent does not control a Creature in this Lane.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local opponentI = 1 - controllerI

        local opponent = STATE.Players[opponentI]
        local lanes = opponent.Landscapes
        local lane = lanes[me.LaneI]

        if lane.Creature == nil then
            me.Attack = me.Attack + 3
        end

    end)

    return result
end