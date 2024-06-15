-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
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