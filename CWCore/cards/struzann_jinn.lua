-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- +2 ATK for each Flooped Creature you control.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local creatures = Common.FloopedCreatures(ownerI)
        me.Attack = me.Attack + #creatures * 2
    end)

    return result
end