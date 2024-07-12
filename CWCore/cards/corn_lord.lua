-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Corn Lord has +1 ATK for each other Cornfield Creature you control.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local ipid = me.Original.IPID

        local creatures = Common.CreaturesTypedExcept(controllerI, CardWars.Landscapes.Cornfield, ipid)

        me.Attack = me.Attack + #creatures
    end)

    return result
end