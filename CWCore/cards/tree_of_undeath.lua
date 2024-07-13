-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Return a random Creature from your discard pile to your hand.',
        function (me, playerI, laneI)
            local cards = CW.CardsInDiscardPileFilter()
                :Creatures()
                :OfPlayer(playerI)
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