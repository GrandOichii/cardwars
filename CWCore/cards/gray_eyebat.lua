-- Pay 1 Action >>> Return a random Useless Swamp Creature from your discard pile to your hand.

-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.PayActionPoints(result, 1,
        function (me, playerI, laneI)
            local idx = Common.RandomCardInDiscard(playerI, function (card)
                return card.Template.Type == 'Creature' and card.Template.Landscape == CardWars.Landscapes.UselessSwamp
            end)
            if idx == nil then
                return
            end
            ReturnToHandFromDiscard(playerI, idx)
        end
    )


    return result
end