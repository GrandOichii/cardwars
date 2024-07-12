-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- +1 DEF for each Cornfield Landscape in play (counting all players).
    CW.State.ModATKDEF(result, function (me)
        local count = #CW.LandscapeFilter()
            :OfLandscapeType(CardWars.Landscapes.Cornfield)
            :Do()

        me.Defense = me.Defense + count
    end)

    return result
end