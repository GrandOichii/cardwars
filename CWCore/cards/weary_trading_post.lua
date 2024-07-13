-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >> Move an exhausted Creature you control to this Landscape (if empty).',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return CW.Landscape.IsEmpty(playerI, laneI)
            end),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():ControlledBy(playerI):Exhausted()
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to move'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            MoveCreature(targets.creature.Original.IPID, laneI)
        end,
        -1
    )

    return result
end