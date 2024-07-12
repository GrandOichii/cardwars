-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (playerI)
            -- Ready each Creature you control.

            local creatures = Common.Creatures(playerI)
            for _, creature in ipairs(creatures) do
                ReadyCard(creature.Original.IPID)
            end
        end
    )

    return result
end