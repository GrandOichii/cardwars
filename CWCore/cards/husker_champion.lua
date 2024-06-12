-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)
    
    -- Husker Champion has +2 ATK and +2 DEF if you control a Building on this Landscape.
    Common.State.ModATKDEF(result, function (me)
        local ownerI = me.Original.OwnerI
        local laneI = me.LaneI
        if STATE.Players[ownerI].Landscapes[laneI].Building ~= nil then
            me.Attack = me.Attack + 2
            me.Defense = me.Defense + 2
        end
    end)

    return result
end