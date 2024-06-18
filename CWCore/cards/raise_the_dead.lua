-- Status: not tested

function _Create()
    local result = CardWars:Spell()
    
    Common.AddRestriction(result,
    function (id, playerI)
        return nil, #Common.CreatureCardsIndiciesInDiscard(playerI) > 0
    end
)

result.EffectP:AddLayer(
    function (id, playerI)
            -- Put a Creature with cost 2 or less from your discard pile into play.
            
            local choices = Common.DiscardPileCardIndicies(playerI, function (card)
                return
                    card.Original.Template.Type == 'Creature' and
                    card.Cost <= 2
            end)
            local choice = ChooseCardInDiscard(playerI, choices, {}, 'Choose a Creature with cost 2 or less to reanimate')
            print(choice[0], choice[1])
            local pI = choice[0]
            if pI ~= playerI then
                -- * shouldn't ever happen
                error('tried to pick card in opponent\'s discard (Raise the Dead)')
                return
            end
            local discardI = choice[1]
            local card = STATE.Players[playerI].DiscardPile[discardI]
            RemoveFromDiscard(playerI, discardI)

            ChooseAndPlaceCreature(playerI, card)
        end
    )

    return result
end