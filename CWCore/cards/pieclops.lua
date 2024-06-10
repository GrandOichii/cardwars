-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Pieclops enters play, heal 1 Damage from each adjacent Creature.

        local adjacent = Common.State:AdjacentLandscapes(GetState(), playerI, laneI)
        for _, landscape in ipairs(adjacent) do
            if landscape.Creature ~= nil then
                HealDamage(landscape.Creature.Original.ID, 1)
            end
        end
    end)

    return result
end