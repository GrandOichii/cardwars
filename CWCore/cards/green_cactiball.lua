-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK for each Green Cactiball you control.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = #CW.CreatureFilter()
            :ControlledBy(controllerI)
            :Named('Green Cactiball')
            :Do()
        me.Attack = me.Attack + count * 2
    end)

    return result
end