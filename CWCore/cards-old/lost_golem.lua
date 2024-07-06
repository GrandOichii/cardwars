-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Lost Golem costs 1 less to play for each other Creature you have played this turn.
    Common.State.ModCostInHand(result, function (me)
        local ownerI = me.Original.OwnerI
        local count = Common.SpellsPlayedThisTurnCount(ownerI)
        Common.Mod.Cost(me, -count)
    end)

    return result
end