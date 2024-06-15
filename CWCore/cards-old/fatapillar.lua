-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- +2 ATK for every 5 cards in your discard pile.
    Common.State.ModATKDEF(result, function (me)
        local count = GetPlayer(me.Original.ControllerI).DiscardPile.Count
        if count == 0 then
            return
        end
        me.Attack = me.Attack + 2 * math.floor(count / 5)
    end)

    return result
end