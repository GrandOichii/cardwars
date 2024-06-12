-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI

        local landscapes = Common.AdjacentLandscapesTyped(ownerI, me.LaneI, CardWars.Landscapes.Cornfield)

        me.Attack = me.Attack + #landscapes
    end)

    return result
end