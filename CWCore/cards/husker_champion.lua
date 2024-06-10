-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- Husker Champion has +2 ATK and +2 DEF if you control a Building on this Landscape.

        local ownerI = me.Original.OwnerI
        local laneI = me.LaneI
        if state.Players[ownerI].Landscapes[laneI].Building ~= nil then
            me.Attack = me.Attack + 2
            me.Defense = me.Defense + 2
        end
    end)

    return result
end