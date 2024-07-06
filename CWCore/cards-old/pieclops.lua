-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Pieclops enters play, heal 1 Damage from each adjacent Creature.

        local adjacent = Common.AdjacentCreatures(playerI, laneI)
        for _, creature in ipairs(adjacent) do
            HealDamage(creature.Original.Card.ID, 1)
        end
    end)

    return result
end