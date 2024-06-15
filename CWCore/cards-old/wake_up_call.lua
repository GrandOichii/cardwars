-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Ready each Creature you control.

            local creatures = Common.Creatures(playerI)
            for _, creature in ipairs(creatures) do
                ReadyCard(creature.Original.Card.ID)
            end
        end
    )

    return result
end