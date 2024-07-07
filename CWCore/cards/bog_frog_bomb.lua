-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(id, playerI, laneI, wasReady)
        -- If Bog Frog Bomb leaves play while Ready, deal 2 Damage to each opposing Creature.

        if not wasReady then
            return
        end
        local creatures = Common.OpposingCreatures(playerI)
        for _, creature in ipairs(creatures) do
            Common.Damage.ToCreatureByCreatureAbility(id, playerI, creature.Original.Card.ID, 2)
        end
    end)

    return result
end