-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- +1 DEF for each Cornfield Landscape in play (counting all players).

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local id = me.Original.Card.ID

            local cornfields = Common:FilterLandscapes( function (landscape)
                return landscape:Is('Cornfield')
            end)

            me.Defense = me.Defense + #cornfields
        end
    end)

    return result
end