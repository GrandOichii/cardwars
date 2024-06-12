-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID

        local creatures = Common.CreaturesTypedExcept(ownerI, CardWars.Landscapes.Cornfield, id)

        me.Attack = me.Attack + #creatures
    end)

    return result
end