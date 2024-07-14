-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (playerI)
            -- Target foe may discard a card. If they do not, deal 2 Damage to each of their Creatures.

            local target = Common.TargetOpponent(playerI)
            if GetHandCount(target) > 0 then
                local accept = YesNo(target, 'Discard a card? (2 Damage to each of your Creatures otherwise)')
                if accept then
                    Common.ChooseAndDiscardCard(target)
                    return
                end
            end

            local ids = CW.IDs(Common.Creatures(target))
            for _, id in ipairs(ids) do
                DealDamageToCreature(id, 2)
            end
        end
    )

    return result
end