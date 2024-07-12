-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Corn Dog has +1 DEF for each Cornfield Landscape you control. If you control 3 or fewer Cornfield Landscapes, Corn Dog has +1 ATK.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = #CW.LandscapeFilter()
            :OwnedBy(controllerI)
            :OfLandscapeType(CardWars.Landscapes.Cornfield)
            :Do()

        me.Defense = me.Defense + count
        if count <= 3 then
            me.Attack = me.Attack + 1
        end
    end)

    return result
end