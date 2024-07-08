-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    local targets = function (playerI, laneI)
        return CW.LandscapeFilter():OnLane(laneI):CanBeFlippedDown(playerI)
    end

    CW.ActivatedAbility.Add(
        result,
        'Discard a card, FLOOP >>> Flip target Landscape in this Lane face down until the start of your next turn.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.DiscardFromHand(1),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #targets(playerI, laneI):Do() > 0
            end)
        ),
        function (me, playerI, laneI)
            local landscape = CW.Target.Landscape(
                targets(playerI, laneI):Do(),
                playerI
            )
            assert(landscape ~= nil, 'activated ability check of card '..me.Original.Card.Template.Name..' returned true, but no flippable landscapes found')
            CW.Landscape.FlipDownUntilNextTurn(playerI, landscape.Original.OwnerI, landscape.Original.Idx)
        end
    )

    return result
end