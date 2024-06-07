

function _Create(props)

    local result = CardWars:Creature(props)

    -- TODO add costF
    -- TODO add checkF
    result:AddFloop(function (ctx)
        -- Return a random Rainbow card from your discard pile to your hand.

        local cards = getCardsInPublicZone(ctx.card.ownerId, CardWars.Zones.Discard)
        local rainbowCards = Util:filter(cards, function (card)
            return card.landscape == CardWars.Landscapes.Rainbow
        end)
        if #rainbowCards == 0 then
            -- TODO disallow user to activate?
            return
        end
        local card = Util:randomItem(rainbowCards)
        MoveToHand(card.id, ctx.card.ownerId)

        -- If you control a Building in this Lane, gain 1 Action.

        local building = GetBuildingInLane(ctx.laneI, ctx.card.ownerId)
        if building == nil then
            return
        end

        AddAction(ctx.card.ownerId, 1)

    end)
    
    return result
end