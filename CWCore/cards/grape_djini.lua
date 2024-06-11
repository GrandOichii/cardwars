-- When Grape Djini enters play, if it replaced a Creature, you may put a card from your discard pile on top of your deck.
-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When  enters play, 

        if not replaced then
            return
        end

        
    end)

    return result
end