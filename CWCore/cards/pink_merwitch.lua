-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.DiscardCard(result,
        'Discard a card >>> Deal 1 Damage to each opposing Creature. (Use only once during each of your turns.)',
        function (me, playerI, laneI)
            local creatures = GetCreatures(1 - playerI)
            for _, creature in ipairs(creatures) do
                DealDamageToCreature(creature.Original.Card.ID, 1)
            end
        end, 1
    )

    return result
end