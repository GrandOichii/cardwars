-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- Corn Dog has +1 DEF for each Cornfield Landscape you control. If you control 3 or fewer Cornfield Landscapes, Corn Dog has +1 ATK.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local count = #Common.LandscapesTyped(controllerI, CardWars.Landscapes.Cornfield)
        me.Defense = me.Defense + count
        if count <= 3 then
            me.Attack = me.Attack + 1
        end
        
    end)

    return result
end