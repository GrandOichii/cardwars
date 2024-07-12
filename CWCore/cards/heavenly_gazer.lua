-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    local getIndicies = function (playerI)
        return CW.Keys(CW.CardsInDiscardPileFilter(playerI):Spells():Do())
    end

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Put a Spell from your discard pile on top of your deck.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #getIndicies(playerI) > 0
            end)
        ),
        function (me, playerI, laneI)
            local indicies = getIndicies(playerI)
            local choice = ChooseCardInDiscard(playerI, indicies, {}, 'Choose a Spell card to place on top of your deck')
            assert(choice[0] == playerI, 'tried to pick card in opponent\'s discard (Heavenly Gazer)')
            local id = choice[1]

            PlaceFromDiscardOnTopOfDeck(playerI, id)

        end
    )

    return result
end