-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Sandsnake enters play, deal 4 Damage to target opposing Creature in this Lane.

        local ipids = CW.IPIDs(Common.TargetableByCreature(Common.OpposingCreaturesInLane(playerI, laneI), playerI, me.Original.IPID))
        if #ipids == 0 then
            return
        end
        local target = TargetCreature(playerI, ipids, 'Choose a creature to deal damage to')
        Common.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, target, 4)
    end)

    return result
end
