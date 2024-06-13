-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- Woadic Chief has +2 ATK this turn for each Spell you have played this turn.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = Common.SpellsPlayedThisTurnCount(controllerI)

        me.Attack = me.Attack + count * 2
    end)

    return result
end