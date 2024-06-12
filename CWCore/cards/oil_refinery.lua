-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    -- Your Creature on this Landscape has +2 DEF for each Oil Refinery you control.
    Common.State.ModATKDEF(result, function (me)
        local creature = STATE.Players[me.Original.OwnerI].Landscapes[me.LaneI].Creature
        if creature == nil then
            return
        end
        creature.Defense = creature.Defense + #Common.BuildingsNamed(me.Original.OwnerI, 'Oil Refinery')
    end)

    return result
end