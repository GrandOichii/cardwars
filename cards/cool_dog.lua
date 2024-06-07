

function _Create(props)

    local result = CardWars:Creature(props)

    result:AddStatic(function (ctx)
        -- Your Creatures on adjacent Lanes may not be Attacked
        
        -- TODO
    end)
    
    return result
end