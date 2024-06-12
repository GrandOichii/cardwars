-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- +2 ATK for each Green Cactiball you control.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local count = Common.CreaturesNamed(ownerI, 'Green Cactiball')
        me.Attack = me.Attack + #count * 2
    end)

    return result
end