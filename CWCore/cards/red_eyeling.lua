-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Return a card with cost 0 from your discard pile to your hand.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.DiscardPileCardIndicies(playerI,
                    function (card)
                        return card.Cost == 0
                    end
                ) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local choices = Common.DiscardPileCardIndicies(playerI,
                function (card)
                    return card.Cost == 0
                end
            )
            local choice = ChooseCardInDiscard(playerI, choices, {}, 'Choose a card with cost 0 in discard to return to your hand')
            assert(choice[0] == playerI, 'tried to choose opponent\'s card (Red Eyeling)')
            ReturnToHandFromDiscard(playerI, choice[1])
        end
    })

    return result
end