-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Woadic Matriarch has +1 ATK for each Rainbow Creature you control.
    Common.State.ModATKDEF(result, function (me)
        local creatures = Common.CreaturesTyped(me.Original.ControllerI, CardWars.Landscapes.Rainbow)
        me.Attack = me.Attack + #creatures

    end)

    return result
end