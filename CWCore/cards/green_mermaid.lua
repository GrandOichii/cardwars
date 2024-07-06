-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.DestroyMe(
        result,
        'Destroy Green Mermaid >>> Deal 1 Damage to each opposing Creature.',
        function (me, playerI, laneI)
            local creatures = Common.OpposingCreatures(playerI)
            for _, creature in ipairs(creatures) do
                Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, creature.Original.Card.ID, 1)
            end
        end
    )

    return result
end