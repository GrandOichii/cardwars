-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target foe may discard a card. If they do not, deal 2 Damage to each of their Creatures.

            local target = Common.TargetOpponent(playerI)
            if GetHandCount(target) > 0 then
                local accept = YesNo(target, 'Discard a card? (2 Damage to each of your Creatures otherwise)')
                if accept then
                    Common.ChooseAndDiscardCard(target)
                    return
                end
            end

            local ids = Common.IDs(Common.Creatures(target))
            for _, cid in ipairs(ids) do
                Common.Damage.ToCreatureBySpell(id, playerI, cid, 2)
            end
        end
    )

    return result
end