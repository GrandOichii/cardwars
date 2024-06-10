-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer)
        -- Corn Dog has +1 DEF for each Cornfield Landscape you control. If you control 3 or fewer Cornfield Landscapes, Corn Dog has +1 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local lanes = STATE.Players[ownerI].Landscapes
            local count = 0
            for i = 1, lanes.Count do
                local lane = lanes[i - 1]
                if lane:Is('Cornfield') then
                    count = count + 1
                end
            end
            me.Defense = me.Defense + count
            if count <= 3 then
                me.Attack = me.Attack + 1
            end
        end

    end)

    return result
end