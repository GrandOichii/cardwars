-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- Corn Dog has +1 DEF for each Cornfield Landscape you control. If you control 3 or fewer Cornfield Landscapes, Corn Dog has +1 ATK.

        local ownerI = me.Original.OwnerI
        local lanes = state.Players[ownerI].Landscapes
        local count = 0
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane.Name == 'Cornfield' then
                count = count + 1
            end
        end
        me.Defense = me.Defense + count
        if count <= 3 then
            me.Attack = me.Attack + 1
        end
    end)

    return result
end