-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Headphone Jerk enters play, if it replaced a Creature, deal 3 Damage to another Creature in this Lane.

        if not replaced then
            return
        end
        local options = Common.IDs(Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.Card.ID))
        if #options == 0 then
            return
        end

        local id = ChooseCreature(playerI, options, 'Choose a creature to deal damage to')
        
        Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, id, 3)
    end)

    return result
end