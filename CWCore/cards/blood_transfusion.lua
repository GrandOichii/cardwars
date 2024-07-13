-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Remove from game a card in any player's discard pile. Heal X Damage from target Creature, where X is the cost of the card removed this way.
    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'card',
                target = CW.Spell.Target.CardInDiscardPile(
                    function (id, playerI)
                        return CW.CardsInDiscardPileFilter()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a card to remove from game'
                    end
                )
            },
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to heal'
                    end
                )
            },
        },
        function (id, playerI, targets)
            local inDiscard = targets.card
            local card = STATE.Players[inDiscard.playerI].DiscardPile[inDiscard.idx]

            RemoveFromDiscard(inDiscard.playerI, inDiscard.idx)
            HealDamage(targets.creature.Original.IPID, card:RealCost())
        end
    )

    return result
end