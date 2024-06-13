-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- +2 DEF for every 5 cards in your discard pile.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local player = STATE.Players[controllerI]
        local discardCount = player.DiscardPile.Count

        if discardCount == 0 then
            return
        end
        me.Defense = me.Defense + math.floor(discardCount / 5) * 2
    end)

    return result
end