

function _Create(props)

    local result = CardWars:Creature(props)

    -- TODO add checkF
    result:AddFloop(function (ctx)
        -- Move a Creature you control to an empty Lane.

        local creatures = GetCreaturesOf(ctx.card.ownerId)
        -- TODO
    end)
    
    return result
end