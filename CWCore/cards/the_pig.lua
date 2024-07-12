-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Flip target Cornfield Landscape in this Lane face down.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Landscape(
                'landscape',
                function (me, playerI, laneI)
                    return CW.LandscapeFilter():OnLane(laneI):OfLandscapeType(CardWars.Landscapes.Cornfield):CanBeFlippedDown(playerI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Cornfield to Flip face down'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local landscape = targets.landscape
            CW.Landscape.FlipDown(landscape.Original.OwnerI, landscape.Original.Idx)
        end
    )

    return result
end