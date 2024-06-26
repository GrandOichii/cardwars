-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Sandhorn Devil enters play, deal 1 Damage to each Creature in play, (including each of your Creatures).

        local ids = Common.IDs(Common.AllPlayers.Creatures())

        for _, id in ipairs(ids) do
            DealDamageToCreature(id, 1)
        end
    end)

    return result
end
