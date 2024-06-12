-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local player = STATE.Players[ownerI]
        local discardCount = player.DiscardPile.Count
        if discardCount == 0 then
            return
        end
        
        me.Attack = me.Attack + math.floor(discardCount / 5)
    end)

    return result
end