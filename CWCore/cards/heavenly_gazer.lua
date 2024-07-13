-- Status: not tested

function _Create()
    local result = CardWars:Creature()


    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Put a Spell from your discard pile on top of your deck.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.CardInDiscardPile(
                'discarded',
                function (me, playerI, laneI)
                    return CW.CardsInDiscardPileFilter():OfPlayer(playerI):Spells():Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Spell card to place on top of your deck'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            PlaceFromDiscardOnTopOfDeck(targets.discarded.playerI, targets.discarded.idx)
        end
    )

    return result
end