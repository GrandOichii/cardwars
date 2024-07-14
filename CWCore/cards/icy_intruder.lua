-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Pay 1 Action, FLOOP >>> Freeze target Landscape.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.PayActionPoints(1),
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Landscape(
                'landscape',
                function (me, playerI, laneI)
                    return CW.LandscapeFilter()
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Landscape to freeze'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            CW.Freeze.Landscape(targets.landscape.Original.OwnerI, targets.landscape.Original.Idx)
        end,
        -1
    )

    return result
end