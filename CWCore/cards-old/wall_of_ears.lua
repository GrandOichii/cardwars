-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- +1 DEF for each Cornfield Landscape in play (counting all players).
    CW.State.ModATKDEF(result, function (me)
        local count = Common.AllPlayers.CountLandscapesTyped(CardWars.Landscapes.Cornfield)
        me.Defense = me.Defense + count
    end)

    return result
end