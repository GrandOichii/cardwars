-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, deal 1 Damage to each Creature on a Landscape with a Frozen token on it.
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local creatures = CW.CreatureFilter():OnFrozenLandscapes():Do()

        for _, creature in ipairs(creatures) do
            CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, controllerI, creature.Original.IPID, 1)
        end
    end)

    return result
end