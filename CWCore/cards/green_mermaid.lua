-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Destroy Green Mermaid >>> Deal 1 Damage to each opposing Creature.',
        CW.ActivatedAbility.Cost.DestroySelf(),
        function (me, playerI, laneI, targets)
            local creatures = CW.CreatureFilter():OpposingTo(playerI):Do()
            for _, creature in ipairs(creatures) do
                CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, creature.Original.IPID, 1)
            end
        end,
        -1
    )

    return result
end