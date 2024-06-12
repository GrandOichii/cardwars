-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    Common.State.ModCostInHand(result, function (me)
        local ownerI = me.Original.OwnerI
        local amount = STATE.Players[ownerI].DiscardPile.Count
        if amount == 0 then
            return
        end
        Common.Mod.Cost(me, -math.floor(amount / 5))
    end)

    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            AddActionPoints(playerI, 1)
        end
    )
    
    return result
end