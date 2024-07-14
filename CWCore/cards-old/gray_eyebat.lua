-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.PayActionPoints(result, 1,
        'Pay 1 Action >>> Return a random Useless Swamp Creature from your discard pile to your hand.',
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