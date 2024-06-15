-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Discard the top 3 cards of your deck. For each Spell discarded this way, target player discards a card.',
        function (me, playerI, laneI)
            local milled = Mill(playerI, 3)
            UpdateState()

            local amount = 0
            for _, card in ipairs(milled) do
                if card.Template.Type == 'Spell' then
                    amount = amount + 1
                end
            end

            if amount == 0 then
                return
            end

            local target = TargetPlayer(playerI, {0, 1}, 'Choose a player who will discard '..amount..' cards from hand')
            Common.DiscardNCards(target, amount)
        end
    )

    return result
end