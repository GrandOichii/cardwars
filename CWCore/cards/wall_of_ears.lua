-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- +1 DEF for each Cornfield Landscape in play (counting all players).

        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID

        local cornfields = Common.State:FilterLandscapes(state, function (landscape)
            return landscape:Is('Cornfield')
        end)

        me.Defense = me.Defense + #cornfields
    end)

    return result
end