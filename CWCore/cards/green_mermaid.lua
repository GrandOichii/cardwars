-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.DestroyMe(
        result,
        'Destroy Green Mermaid >>> Deal 1 Damage to each opposing Creature.',
        function (me, playerI, laneI)
            local creatures = Common.OpposingCreatures(playerI)
            for _, creature in ipairs(creatures) do
                CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, creature.Original.IPID, 1)
            end
        end
    )

    return result
end