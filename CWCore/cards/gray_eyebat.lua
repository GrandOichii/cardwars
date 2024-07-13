-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Pay 1 Action >>> Return a random Useless Swamp Creature from your discard pile to your hand.
    CW.ActivatedAbility.Add(
        result,
        'Pay 1 Action >>> Return a random Useless Swamp Creature from your discard pile to your hand.',
        CW.ActivatedAbility.Cost.PayActionPoints(1),
        function (me, playerI, laneI)
            local cards = CW.CardsInDiscardPileFilter()
                :OfLandscapeType(CardWars.Landscapes.UselessSwamp)
                :Creatures()
                :Do()
            local pair = CW.Common.RandomCardInDiscard(playerI, cards)
            if pair == nil then
                return
            end
            ReturnToHandFromDiscard(playerI, pair.idx)
        end
    )

    return result
end