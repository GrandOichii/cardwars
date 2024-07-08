-- Status: implemented, CW

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK for each Flooped Creature you control.
    CW.State.ModATKDEF(result, function (me)
        local creatures = CW.CreatureFilter()
            :ControlledBy(me.Original.ControllerI)
            :Flooped()
            :Do()

        me.Attack = me.Attack + #creatures * 2
    end)

    return result
end