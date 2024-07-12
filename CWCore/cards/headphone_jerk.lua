-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Headphone Jerk enters play, if it replaced a Creature, deal 3 Damage to another Creature in this Lane.

        if not replaced then
            return
        end
        local options = CW.IPIDs(Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.IPID))
        if #options == 0 then
            return
        end

        local ipid = ChooseCreature(playerI, options, 'Choose a creature to deal damage to')
        
        Common.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, ipid, 3)
    end)

    return result
end