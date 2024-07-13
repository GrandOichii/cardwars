-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target foe may discard a card with cost 2 or greater. If they do not, deal 5 Damage to that foe.

            local target = CW.Target.Opponent(playerI)
            local cards = CW.CardsInHandFilter(target):CostGte(2):Do()
            local indicies = CW.Keys(cards)
            if #indicies > 0 then
                local accept = YesNo(target, 'Discard a card? (2 Damage to each of your Creatures otherwise)')
                if accept then
                    local idx = ChooseCardInHand(target, indicies, 'Discard a card with cost 2 or greater')

                    DiscardFromHand(target, idx)
                    return
                end
            end

            DealDamageToPlayer(target, 5)
        end
    )

    return result
end