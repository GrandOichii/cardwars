-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    -- When Sandsnake enters play, deal 4 Damage to target opposing Creature in this Lane.
    result:OnEnter(function(me, playerI, laneI, replaced)
        local ids = CW.IDs(Common.Targetable(playerI, Common.OpposingCreaturesInLane(playerI, laneI)))
        if #ids == 0 then
            return
        end
        local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
        DealDamageToCreature(target, 4)
        
    end)

    return result
end