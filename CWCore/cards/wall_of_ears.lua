-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- +1 DEF for each Cornfield Landscape in play (counting all players).
    Common.State.ModATKDEF(result, function (me)
        local cornfields = Common.AllPlayers.LandscapesTyped(CardWars.Landscapes.Cornfield)
        me.Defense = me.Defense + #cornfields
    end)

    return result
end