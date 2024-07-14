-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Blueberry Pieclops costs 1 less to play for each Spell you have played this turn.
    CW.State.ModCostInHand(result, function (me)
        local count = #CW.CardsPlayedThisTurnFilter(me.Original.OwnerI)
            :Spells()
            :Do()
        CW.Mod.Cost(me, -count)
    end)

    return result
end