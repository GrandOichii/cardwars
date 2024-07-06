-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Blueberry Djini enters play, if it replaced a Creature, draw two cards.

        if replaced then
            Draw(playerI, 2)
        end
    end)

    return result
end