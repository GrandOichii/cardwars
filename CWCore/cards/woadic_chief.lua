-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Woadic Chief has +2 ATK this turn for each Spell you have played this turn.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = #CW.CardsPlayedThisTurnFilter(controllerI)
            :Spells()
            :Do()

        me.Attack = me.Attack + count * 2
    end)

    return result
end