-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- +1 DEF for each Cornfield Landscape in play (counting all players).
    Common.State.ModATKDEF(result, function (me)
        local count = Common.AllPlayers.CountLandscapesTyped(CardWars.Landscapes.Cornfield)
        me.Defense = me.Defense + count
    end)

    return result
end