-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- Husker Knight has +1 ATK and +2 DEF for each Cornfield Landscape you control. 
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = #Common.LandscapesTyped(controllerI, CardWars.Landscapes.Cornfield)

        me.Attack = me.Attack + count
        me.Defense = me.Defense + count * 2
    end)

    return result
end