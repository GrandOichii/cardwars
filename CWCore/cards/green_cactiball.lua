-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK for each Green Cactiball you control.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = Common.CreaturesNamed(controllerI, 'Green Cactiball')
        me.Attack = me.Attack + #count * 2
    end)

    return result
end