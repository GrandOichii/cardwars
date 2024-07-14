-- Status: implemented, requires a lot of testing

function _Create()
    local result = CardWars:Spell()

    -- Put a Creature with cost 2 or less from your discard pile into play.
    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'card',
                target = CW.Spell.Target.CardInDiscardPile(
                    function (id, playerI)
                        return CW.CardsInDiscardPileFilter()
                            :Creatures()
                            :CostLte(2)
                            :Custom(function (card)
                                return #LandscapesAvailableForCreature(playerI, card) > 0
                            end)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a Creature card to resurrect'
                    end
                )
            },
        },
        function (id, playerI, targets)
            local inDiscard = targets.card
            local card = STATE.Players[inDiscard.playerI].DiscardPile[inDiscard.idx]
            RemoveFromDiscard(playerI, inDiscard.idx)

            PlaceCreature(playerI, card, true)
        end
    )

    return result
end