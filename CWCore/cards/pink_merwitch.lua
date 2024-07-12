-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.DiscardCard(result,
        'Discard a card >>> Deal 1 Damage to each opposing Creature. (Use only once during each of your turns.)',
        function (me, playerI, laneI)
            local creatures = GetCreatures(1 - playerI)
            for _, creature in ipairs(creatures) do
                Common.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, creature.Original.IPID, 1)
            end
        end, 1
    )

    return result
end