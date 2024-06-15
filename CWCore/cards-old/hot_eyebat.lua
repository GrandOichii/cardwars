-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Play Hot Eyebat only if you have 10 or more cards in your discard pile.
    Common.AddRestriction(result,
        function (playerI)
            return nil, STATE.Players[playerI].DiscardPile.Count > 10
        end
    )

    return result
end