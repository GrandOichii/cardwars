-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Future Scholar enters play, if it replaced a Creature, gain 1 Action.
    
        if replaced then
            AddActionPoints(playerI, 1)
        end
    end)

    return result
end