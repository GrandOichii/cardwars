-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- FLOOP >>> Draw a card, then discard a card.
    Common.ActivatedEffects.Floop(result, function (me, playerI, laneI)
        Draw(playerI, 1)
        UpdateState()

        -- * hand count still be 0 if no cards in deck!
        Common.ChooseAndDiscardCard(playerI)
    end)

    return result
end