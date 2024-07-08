-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.State.ModATKDEF(result, function (me)
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