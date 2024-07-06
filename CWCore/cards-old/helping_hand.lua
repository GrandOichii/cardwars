-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Return a Building from your discard pile to your hand.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.DiscardPileCardIndicies(playerI,
                    function(card)
                        return card.Original.Template.Type == 'Building'
                    end
                ) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.DiscardPileCardIndicies(playerI,
                function(card)
                    return card.Original.Template.Type == 'Building'
                end
            )
            local choice = ChooseCardInDiscard(playerI, ids, {}, 'Choose building card in discard to return to your hand')
            if choice[0] ~= playerI then
                error('tried to choose opponent\'s card (Helping Hand)')
            end
            ReturnToHandFromDiscard(playerI, choice[1])
        end
    })

    return result
end