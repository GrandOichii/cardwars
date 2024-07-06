-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (playerI)
            -- Target foe may discard a card with cost 2 or greater. If they do not, deal 5 Damage to that foe.

            local target = Common.TargetOpponent(playerI)
            local cards = Common.CardsInHandWithCostGreaterOrEqual(target, 2)
            if #cards > 0 then
                local accept = YesNo(target, 'Discard a card? (2 Damage to each of your Creatures otherwise)')
                if accept then
                    Common.ChooseAndDiscardCard(target)
                    return
                end
            end

            DealDamageToPlayer(target, 5)
        end
    )

    return result
end