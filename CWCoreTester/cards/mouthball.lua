-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- +2 DEF for every 5 cards in your discard pile.

        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID
        local player = state.Players[ownerI]
        local discardCount = player.DiscardPile.Count

        me.Defense = me.Defense + math.floor(discardCount / 5) * 2
    end)

    return result
end