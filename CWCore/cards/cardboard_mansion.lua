-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- Cardboard Mansion costs 1 less to play for every 5 cards in your Discard Pile. 
    Common.State.ModCostInHand(result, function (me)
        local ownerI = me.Original.OwnerI
        local amount = STATE.Players[ownerI].DiscardPile.Count
        if amount == 0 then
            return
        end
        Common.Mod.Cost(me, -math.floor(amount / 5))
    end)

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Gain 1 Action.',
        function (me, playerI, laneI)
            AddActionPoints(playerI, 1)
        end
    )
    
    return result
end