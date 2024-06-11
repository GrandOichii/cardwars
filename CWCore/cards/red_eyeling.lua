
-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Return a card with cost 0 from your discard pile to your hand.

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and 
                #Common.DiscardPileCardIndicies(playerI,
                    function (card)
                        return card.Cost == 0
                    end
                )
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local choices = #Common.DiscardPileCardIndicies(playerI,
                function (card)
                    return card.Cost == 0
                end
            )
            local choice = ChooseCardInDiscard(playerI, choices, {}, 'Choose a card with cost 0 in discard to return to your hand')
            if choice[0] ~= playerI then
                error('tried to choose opponent\'s card (Helping Hand)')
            end
            ReturnToHandFromDiscard(playerI, choice[1])
        end
    })

    return result
end