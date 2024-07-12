-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Put a Spell from your discard pile on top of your deck.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.DiscardPileCardIndicies(playerI, function (card)
                    return card.Original.Template.Type == 'Spell'
                end) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.DiscardPileCardIndicies(playerI, function (card)
                return card.Original.Template.Type == 'Spell'
            end)
            local choice = ChooseCardInDiscard(playerI, ids, {}, 'Choose a Spell card to place on top of your deck')
            assert(choice[0] == playerI, 'tried to pick card in opponent\'s discard (Heavenly Gazer)')
            local id = choice[1]

            PlaceFromDiscardOnTopOfDeck(playerI, id)

        end
    })

    return result
end