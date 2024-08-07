-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    -- +1 ATK for every 5 cards in your discard pile.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local player = STATE.Players[controllerI]
        local discardCount = player.DiscardPile.Count
        if discardCount == 0 then
            return
        end

        me.Attack = me.Attack + math.floor(discardCount / 5)
    end)

    return result
end