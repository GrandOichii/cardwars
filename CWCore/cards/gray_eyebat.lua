-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Pay 1 Action >>> Return a random Useless Swamp Creature from your discard pile to your hand.
    Common.ActivatedEffects.PayActionPoints(result, 1,
        function (me, playerI, laneI)
            local idx = Common.RandomCardInDiscard(playerI, function (card)
                return card.Original.Template.Type == 'Creature' and card.Original.Template.Landscape == CardWars.Landscapes.UselessSwamp
            end)
            if idx == nil then
                return
            end
            ReturnToHandFromDiscard(playerI, idx)
        end
    )


    return result
end