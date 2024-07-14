-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'Discard a card, FLOOP >>> Flip target Landscape in this Lane face down until the start of your next turn.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.DiscardFromHand(1),
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Landscape(
                'landscape',
                function (me, playerI, laneI)
                    return CW.LandscapeFilter():OnLane(laneI):CanBeFlippedDown(playerI)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Landscape to flip face down'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local landscape = targets.landscape

            CW.Landscape.FlipDownUntilNextTurn(playerI, landscape.Original.OwnerI, landscape.Original.Idx)
        end
    )

    return result
end