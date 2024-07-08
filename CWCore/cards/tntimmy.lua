-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(id, playerI, laneI, wasReady)
        -- When TNTimmy leaves play, deal 1 Damage to each opposing Creature.

        local creatures = Common.OpposingCreatures(playerI)
        for _, creature in ipairs(creatures) do
            Common.Damage.ToCreatureByCreatureAbility(id, playerI, creature.Original.Card.ID, 1)
        end
    end)

    return result
end