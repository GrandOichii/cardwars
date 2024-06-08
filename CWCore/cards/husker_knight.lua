-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- Husker Knight has +1 ATK and +2 DEF for each Cornfield Landscape you control. 

        local ownerI = me.Original.OwnerI
        local lanes = state.Players[ownerI].Landscapes
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane:Is('Cornfield') then
                me.Attack = me.Attack + 1
                me.Defense = me.Defense + 2
            end
        end
    end)

    return result
end