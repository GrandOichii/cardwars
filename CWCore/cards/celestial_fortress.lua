-- Status: partially implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    Common.State.ModATKDEF(result, function (me)
        local landscape = STATE.Players[1 - me.Original.OwnerI].Landscapes[me.LaneI]
        if landscape.Creature ~= nil then
            landscape.Creature.Defense = landscape.Creature.Defense - 2
        end
    end)

    return result
end