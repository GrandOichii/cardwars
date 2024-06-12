-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Kernel Queen has +1 ATK for each Flooped Creature you control.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local creatures = Common.FloopedCreatures(ownerI)
    
        me.Attack = me.Attack + #creatures
        me.Defense = me.Defense + #creatures    
    end)

    return result
end