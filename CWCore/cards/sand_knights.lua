-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- +2 ATK if you control a Blue Plains Landscape.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local count = CW.Count.LandscapesOfType(CardWars.Landscapes.BluePlains, controllerI)

        if count > 0 then
            me.Attack = me.Attack + 2
        end
    end)

    return result
end