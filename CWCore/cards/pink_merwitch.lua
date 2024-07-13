-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.DiscardCards(
        result,
        'Discard a card >>> Deal 1 Damage to each opposing Creature. (Use only once during each of your turns.)',
        1,
        function (me, playerI, laneI)
            local creatures = CW.CreatureFilter()
                :OpposingTo(playerI)
                :Do()
            for _, creature in ipairs(creatures) do
                CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, creature.Original.IPID, 1)
            end
        end,
        nil,
        1
    )

    return result
end