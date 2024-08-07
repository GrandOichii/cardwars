-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Pieclops enters play, heal 1 Damage from each adjacent Creature.

        local adjacent = CW.CreatureFilter()
            :AdjacentToLane(playerI, laneI)
            :Do()
        for _, creature in ipairs(adjacent) do
            HealDamage(creature.Original.IPID, 1)
        end
    end)

    return result
end