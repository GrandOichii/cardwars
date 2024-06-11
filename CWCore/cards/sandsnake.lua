-- When Sandsnake enters play, deal 4 Damage to target opposing Creature in this Lane.

-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When  enters play, 
    
        local ids = Common.IDs(Common.CreaturesInLane(laneI))
        local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
        DealDamageToCreature(target, 4)
        
    end)

    return result
end