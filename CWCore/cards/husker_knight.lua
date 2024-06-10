-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- Husker Knight has +1 ATK and +2 DEF for each Cornfield Landscape you control. 

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            print(layer)
            local ownerI = me.Original.OwnerI
            local lanes = STATE.Players[ownerI].Landscapes
            for i = 1, lanes.Count do
                local lane = lanes[i - 1]
                if lane:Is('Cornfield') then
                    me.Attack = me.Attack + 1
                    me.Defense = me.Defense + 2
                end
            end

        end

    end)

    return result
end