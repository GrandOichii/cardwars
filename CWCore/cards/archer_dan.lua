-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Destroy target Building in Archer Dan\'s Lane.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Building(
                'building',
                function (me, playerI, laneI)
                    return CW.BuildingFilter():InLane(laneI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Buidling to destroy'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            DestroyBuilding(targets.building.Original.IPID)
        end
    )

    return result
end