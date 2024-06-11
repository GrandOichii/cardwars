-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Pieclops enters play, heal 1 Damage from each adjacent Creature.

        local adjacent = Common.AdjacentCreatures(playerI, laneI)
        for _, creature in ipairs(adjacent) do
            HealDamage(creature.Original.ID, 1)
        end
    end)

    return result
end