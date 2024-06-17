-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- If you have 10 or more cards in your discard pile, pay 2 fewer Actions to play Teeth Leaf.
    Common.State.ModCostInHand(result, function (me)
        local ownerI = me.Original.OwnerI
        local player = STATE.Players[ownerI]
        local discardCount = player.DiscardPile.Count
        if discardCount > 10 then
            Common.Mod.Cost(me, -2)
        end
    end)

    return result
end