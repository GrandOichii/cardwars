-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Sandsnake enters play, deal 4 Damage to target opposing Creature in this Lane.

        local ids = Common.IDs(Common.TargetableByCreature(Common.OpposingCreaturesInLane(playerI, laneI), playerI, me.Original.Card.ID))
        if #ids == 0 then
            return
        end
        local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
        Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, target, 4)
    end)

    return result
end
