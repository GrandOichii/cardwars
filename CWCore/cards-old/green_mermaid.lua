-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.DestroyMe(
        result,
        'Destroy Green Mermaid >>> Deal 1 Damage to each opposing Creature.',
        function (me, playerI, laneI)
            local creatures = Common.OpposingCreatures(playerI)
            for _, creature in ipairs(creatures) do
                DealDamageToCreature(creature.Original.Card.ID, 1)
            end
        end
    )

    return result
end