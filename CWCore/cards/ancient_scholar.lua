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

            local pair = CW.Common.RandomCardInDiscard(playerI, cards)

            if pair ~= nil then
                ReturnToHandFromDiscard(playerI, pair.idx)
            end

            if CW.Common.YouControlABuildingInThisLane(playerI, laneI) then
                AddActionPoints(playerI, 1)
            end
        end
    )

    return result
end