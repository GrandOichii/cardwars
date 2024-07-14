-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Move a Creature in an adjacent Lane to this Lane (if empty).',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return CW.Landscape.IsEmpty(playerI, laneI)
            end),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():AdjacentToLane(playerI, laneI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to move'
                end
            )
        ),
        function (me, playerI, laneI, targets)

            MoveCreature(targets.creature.Original.IPID, laneI)
        end
    )

    return result
end