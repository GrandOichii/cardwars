-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Blueberry Djini enters play, if it replaced a Creature, draw two cards.

        if replaced then
            Draw(playerI, 2)
        end
    end)

    return result
end