-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Cardboard Mansion costs 1 less to play for every 5 cards in your Discard Pile. 

        if layer == CardWars.ModificationLayers.CARD_COST and zone == CardWars.Zones.HAND then
            local ownerI = me.Original.OwnerI
            local amount = STATE.Players[ownerI].DiscardPile.Count
            if amount == 0 then
                return
            end
            Common.Mod.Cost(me, -math.floor(amount / 5))
        end

    end)

    result:AddActivatedEffect({
        -- FLOOP >>> Gain 1 Action.

        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            AddActionPoints(playerI, 1)
        end
    })

    return result
end