-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Goat enters play, if it replaced a Creature, draw a card.

        if replaced then
            Draw(playerI, 1)
        end
    end)

    return result
end