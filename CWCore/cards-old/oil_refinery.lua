-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- Your Creature on this Landscape has +2 DEF for each Oil Refinery you control.
    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local creature = STATE.Players[controllerI].Landscapes[me.LaneI].Creature
        if creature == nil then
            return
        end
        creature.Defense = creature.Defense + #Common.BuildingsNamed(controllerI, 'Oil Refinery')
    end)

    return result
end