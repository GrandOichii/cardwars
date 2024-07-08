-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Headphone Jerk enters play, if it replaced a Creature, deal 3 Damage to another Creature in this Lane.
        local me = STATE.Players[playerI].Landscapes[laneI].Creature
        if me == nil then
            -- * shouldn't ever happen
            error('tried to fetch myself, but i was nil (Headphone Jerk)')
        end

        if replaced then
            local options = CW.IDs(Common.AllPlayers.CreaturesInLaneExcept(laneI, me.Original.Card.ID))
            if #options == 0 then
                return
            end

            local id = ChooseCreature(playerI, options, 'Choose a creature to deal damage to')
            DealDamageToCreature(id, 3)
        end
    end)

    return result
end