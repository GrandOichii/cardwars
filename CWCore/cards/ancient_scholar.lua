-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Return a random Rainbow card from your Discard Pile to your Hand. If you Control a Building in this Lane, gain 1 Action.',
        CW.ActivatedAbility.Cost.Floop(),
        function (me, playerI, laneI)
            local cards = CW.CardsInDiscardPileFilter(playerI):OfLandscapeType(CardWars.Landscapes.Rainbow):Do()

            if #cards > 0 then
                local indicies = CW.Keys(cards)
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