-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(ipid, id, playerI, laneI, wasReady)
        -- When TNTimmy leaves play, deal 1 Damage to each opposing Creature.

        local creatures = CW.CreatureFilter():OpposingTo(playerI):Do()
        for _, creature in ipairs(creatures) do
            CW.Damage.ToCreatureByCreatureAbility(ipid, playerI, creature.Original.IPID, 1)
        end
    end)

    return result
end