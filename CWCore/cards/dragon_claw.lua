-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Move a Creature you control to an empty Lane.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():ControlledBy(playerI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to move'
                end
            ),
            CW.ActivatedAbility.Cost.Target.Lane(
                'lane',
                function (me, playerI, laneI)
                    return CW.LaneFilter(playerI):Empty():Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Lane to move '..targets.creature.Original.Card.Template.Name..' to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            MoveCreature(targets.creature.Original.IPID, targets.lane)
        end
    )

    return result
end