-- Remove from game a card in any player's discard pile. Heal X Damage from target Creature, where X is the cost of the card removed this way.
-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.SpellTargetable(playerI, Common.AllPlayers.Creatures()) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- 
            
            local choices = Common.DiscardPileCardIndicies(playerI, function (_) return true end)
            local opponentChoices = Common.DiscardPileCardIndicies(1 - playerI, function (_) return true end)
            if (#choices + #opponentChoices) == 0 then
                return
            end
            local choice = ChooseCardInDiscard(playerI, choices, opponentChoices, 'Choose a card to remove from the game')
            local card = STATE.Players[choice[0]].DiscardPile[choice[1]]

            RemoveFromDiscard(choice[0], choice[1])

            local ids = Common.IDs(Common.Targetable(playerI, Common.AllPlayers.Creatures()))
            local target = TargetCreature(playerI, ids, 'Choose a creature to heal')
            HealDamage(target, card:RealCost())
        end
    )

    return result
end