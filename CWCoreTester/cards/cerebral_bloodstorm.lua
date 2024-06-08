-- Status: Implemented

function _Create(props)
    local result = CardWars:Spell(props)
    
    result.EffectP:AddLayer(
        function (playerI)
            -- Deal 1 Damage to each opposing Creature.

            local opponentI = 1 - playerI
            local creatures = GetCreatures(opponentI)
            for _, creature in ipairs(creatures) do
                DealDamageToCreature(creature.Original.Card.ID, 1)
            end
        end
    )

    return result
end