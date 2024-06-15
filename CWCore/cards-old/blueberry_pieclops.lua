-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- Blueberry Pieclops costs 1 less to play for each Spell you have played this turn.
    Common.State.ModCostInHand(result, function (me)
        Common.Mod.Cost(me, -Common.SpellsPlayedThisTurnCount(me.Original.OwnerI))
    end)

    return result
end