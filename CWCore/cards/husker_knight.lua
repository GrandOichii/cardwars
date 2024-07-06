-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Husker Knight has +1 ATK and +2 DEF for each Cornfield Landscape you control. 
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = Common.CountLandscapesTyped(controllerI, CardWars.Landscapes.Cornfield)

        me.Attack = me.Attack + count
        me.Defense = me.Defense + count * 2
    end)

    return result
end