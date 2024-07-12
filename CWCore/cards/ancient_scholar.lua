-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Return a random Rainbow card from your Discard Pile to your Hand. If you Control a Building in this Lane, gain 1 Action.',
        CW.ActivatedAbility.Cost.Floop(),
        function (me, playerI, laneI)
            local cards = CW.CardsInDiscardPileFilter()
                :OfPlayer(playerI)
                :OfLandscapeType(CardWars.Landscapes.Rainbow)
                :Do()

            local indicies = {}
            for _, pair in ipairs(cards) do
                if pair.card.Original.OwnerI == playerI then
                    indicies[#indicies+1] = pair.idx
                end
            end

            if #indicies > 0 then
                local idx = CW.Random(indicies)
                ReturnToHandFromDiscard(playerI, idx)
            end

            if CW.Common.YouControlABuildingInThisLane(playerI, laneI) then
                AddActionPoints(playerI, 1)
            end
        end
    )

    return result
end