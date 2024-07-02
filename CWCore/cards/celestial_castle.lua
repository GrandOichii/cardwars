-- Your Creature in this Lane has +3 DEF.

function _Create()
    local result = CardWars:InPlay()

    Common.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local player = STATE.Players[controllerI]
        local creature = player.Landscapes[me.LaneI].Creature

        if creature ~= nil then
            creature.Defense = creature.Defense + 3
        end
    end)

    return result
end