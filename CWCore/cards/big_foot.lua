-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Flip target face-down Landscape you control face up. ',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Landscape(
                'landscape',
                function (me, playerI, laneI)
                    return CW.LandscapeFilter():CanBeFlippedUp(playerI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Landscape to Flip face up'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local landscape = targets.landscape
            TurnLandscapeFaceUp(landscape.Original.OwnerI, landscape.Original.Idx)
        end
    )

    return result
end