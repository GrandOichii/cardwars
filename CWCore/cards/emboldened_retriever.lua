-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    -- Each time Emboldened Retriever attacks, you may draw a card. Much ball. Wow.
    result.OnAttackP:AddLayer(
        function (playerI, laneI)
            Draw(playerI, 1)
            return nil, true
        end
    )


    return result
end