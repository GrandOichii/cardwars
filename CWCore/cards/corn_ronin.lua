-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- +1 ATK for each adjacent Cornfield Landscape.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI

        local landscapes = CW.LandscapeFilter()
            :OfLandscapeType(CardWars.Landscapes.Cornfield)
            :AdjacentTo(controllerI, me.LaneI)
            :Do()

        me.Attack = me.Attack + #landscapes
    end)

    return result
end