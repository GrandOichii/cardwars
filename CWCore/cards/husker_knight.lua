-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Husker Knight has +1 ATK and +2 DEF for each Cornfield Landscape you control. 
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = CW.Count.LandscapesOfType(CardWars.Landscapes.Cornfield, controllerI)

        me.Attack = me.Attack + count
        me.Defense = me.Defense + count * 2
    end)

    return result
end