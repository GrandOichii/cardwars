-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    -- When Sandsnake enters play, deal 4 Damage to target opposing Creature in this Lane.
    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        local ids = Common.IDs(Common.Targetable(playerI, Common.OpposingCreaturesInLane(playerI, laneI)))
        if #ids == 0 then
            return
        end
        local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
        DealDamageToCreature(target, 4)
        
    end)

    return result
end