-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- If you played one or more Rainbow cards this turn, Infant Scholar has +3 ATK this turn,
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = Common.CardsPlayedThisTurnTyped(controllerI, CardWars.Landscapes.Rainbow)
        if count > 3 then
            me.Attack = me.Attack + 3
        end
    end)

    return result
end