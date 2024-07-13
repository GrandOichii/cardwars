-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Return a card with cost 0 from your discard pile to your hand.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.CardInDiscardPile(
                'discarded',
                function (me, playerI, laneI)
                    return CW.CardsInDiscardPileFilter()
                        :OfPlayer(playerI)
                        :OfCost(0)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a 0-cost card in your discard pile to return to your hand'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            ReturnToHandFromDiscard(playerI, targets.discarded.idx)
        end
    )

    return result
end