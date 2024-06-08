-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- +1 ATK for every 5 cards in your discard pile.

        local ownerI = me.Original.OwnerI
        local player = state.Players[ownerI]
        local discardCount = player.DiscardPile.Count

        me.Attack = me.Attack + math.floor(discardCount / 5)
    end)

    return result
end